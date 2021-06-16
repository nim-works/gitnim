#
#
#           The Nim Compiler
#        (c) Copyright 2013 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

# This module implements the semantic checking pass.

import
  ast, strutils, options, astalgo, trees,
  wordrecg, ropes, msgs, idents, renderer, types, platform, math,
  magicsys, nversion, nimsets, semfold, modulepaths, importer,
  procfind, lookups, pragmas, passes, semdata, semtypinst, sigmatch,
  intsets, transf, vmdef, vm, aliases, cgmeth, lambdalifting,
  evaltempl, patterns, parampatterns, sempass2, linter, semmacrosanity,
  lowerings, plugins/active, lineinfos, strtabs, int128,
  isolation_check, typeallowed, modulegraphs, enumtostr, concepts, astmsgs

when defined(nimfix):
  import nimfix/prettybase

when not defined(leanCompiler):
  import spawn

# implementation

proc semExpr(c: PContext, n: PNode, flags: TExprFlags = {}): PNode
proc semExprWithType(c: PContext, n: PNode, flags: TExprFlags = {}): PNode
proc semExprNoType(c: PContext, n: PNode): PNode
proc semExprNoDeref(c: PContext, n: PNode, flags: TExprFlags = {}): PNode
proc semProcBody(c: PContext, n: PNode): PNode

proc fitNode(c: PContext, formal: PType, arg: PNode; info: TLineInfo): PNode
proc changeType(c: PContext; n: PNode, newType: PType, check: bool)

proc semTypeNode(c: PContext, n: PNode, prev: PType): PType
proc semStmt(c: PContext, n: PNode; flags: TExprFlags): PNode
proc semOpAux(c: PContext, n: PNode)
proc semParamList(c: PContext, n, genericParams: PNode, s: PSym)
proc addParams(c: PContext, n: PNode, kind: TSymKind)
proc maybeAddResult(c: PContext, s: PSym, n: PNode)
proc tryExpr(c: PContext, n: PNode, flags: TExprFlags = {}): PNode
proc activate(c: PContext, n: PNode)
proc semQuoteAst(c: PContext, n: PNode): PNode
proc finishMethod(c: PContext, s: PSym)
proc evalAtCompileTime(c: PContext, n: PNode): PNode
proc indexTypesMatch(c: PContext, f, a: PType, arg: PNode): PNode
proc semStaticExpr(c: PContext, n: PNode): PNode
proc semStaticType(c: PContext, childNode: PNode, prev: PType): PType
proc semTypeOf(c: PContext; n: PNode): PNode
proc computeRequiresInit(c: PContext, t: PType): bool
proc defaultConstructionError(c: PContext, t: PType, info: TLineInfo)
proc hasUnresolvedArgs(c: PContext, n: PNode): bool
proc isArrayConstr(n: PNode): bool {.inline.} =
  result = n.kind == nkBracket and
    n.typ.skipTypes(abstractInst).kind == tyArray

template semIdeForTemplateOrGenericCheck(conf, n, requiresCheck) =
  # we check quickly if the node is where the cursor is
  when defined(nimsuggest):
    if n.info.fileIndex == conf.m.trackPos.fileIndex and n.info.line == conf.m.trackPos.line:
      requiresCheck = true

template semIdeForTemplateOrGeneric(c: PContext; n: PNode;
                                    requiresCheck: bool) =
  # use only for idetools support; this is pretty slow so generics and
  # templates perform some quick check whether the cursor is actually in
  # the generic or template.
  when defined(nimsuggest):
    if c.config.cmd == cmdIdeTools and requiresCheck:
      #if optIdeDebug in gGlobalOptions:
      #  echo "passing to safeSemExpr: ", renderTree(n)
      discard safeSemExpr(c, n)

proc fitNodePostMatch(c: PContext, formal: PType, arg: PNode): PNode =
  let x = arg.skipConv
  if x.kind in {nkPar, nkTupleConstr, nkCurly} and formal.kind != tyUntyped:
    changeType(c, x, formal, check=true)
  result = arg
  result = skipHiddenSubConv(result, c.graph, c.idgen)


proc fitNode(c: PContext, formal: PType, arg: PNode; info: TLineInfo): PNode =
  if arg.typ.isNil:
    localError(c.config, arg.info, "expression has no type: " &
               renderTree(arg, {renderNoComments}))
    # error correction:
    result = copyTree(arg)
    result.typ = formal
  else:
    result = indexTypesMatch(c, formal, arg.typ, arg)
    if result == nil:
      typeMismatch(c.config, info, formal, arg.typ, arg)
      # error correction:
      result = copyTree(arg)
      result.typ = formal
    else:
      result = fitNodePostMatch(c, formal, result)

proc fitNodeForLocalVar(c: PContext, formal: PType, arg: PNode; info: TLineInfo): PNode =
  let a = fitNode(c, formal, arg, info)
  if formal.kind in {tyVar, tyLent}:
    #classifyViewType(formal) != noView:
    result = newNodeIT(nkHiddenAddr, a.info, formal)
    result.add a
  else:
   result = a

proc inferWithMetatype(c: PContext, formal: PType,
                       arg: PNode, coerceDistincts = false): PNode

template commonTypeBegin*(): PType = PType(kind: tyUntyped)

proc commonType*(c: PContext; x, y: PType): PType =
  # new type relation that is used for array constructors,
  # if expressions, etc.:
  if x == nil: return x
  if y == nil: return y
  var a = skipTypes(x, {tyGenericInst, tyAlias, tySink})
  var b = skipTypes(y, {tyGenericInst, tyAlias, tySink})
  result = x
  if a.kind in {tyUntyped, tyNil}: result = y
  elif b.kind in {tyUntyped, tyNil}: result = x
  elif a.kind == tyTyped: result = a
  elif b.kind == tyTyped: result = b
  elif a.kind == tyTypeDesc:
    # turn any concrete typedesc into the abstract typedesc type
    if a.len == 0: result = a
    else:
      result = newType(tyTypeDesc, nextTypeId(c.idgen), a.owner)
      rawAddSon(result, newType(tyNone, nextTypeId(c.idgen), a.owner))
  elif b.kind in {tyArray, tySet, tySequence} and
      a.kind == b.kind:
    # check for seq[empty] vs. seq[int]
    let idx = ord(b.kind == tyArray)
    if a[idx].kind == tyEmpty: return y
  elif a.kind == tyTuple and b.kind == tyTuple and a.len == b.len:
    var nt: PType
    for i in 0..<a.len:
      let aEmpty = isEmptyContainer(a[i])
      let bEmpty = isEmptyContainer(b[i])
      if aEmpty != bEmpty:
        if nt.isNil:
          nt = copyType(a, nextTypeId(c.idgen), a.owner)
          copyTypeProps(c.graph, c.idgen.module, nt, a)

        nt[i] = if aEmpty: b[i] else: a[i]
    if not nt.isNil: result = nt
    #elif b[idx].kind == tyEmpty: return x
  elif a.kind == tyRange and b.kind == tyRange:
    # consider:  (range[0..3], range[0..4]) here. We should make that
    # range[0..4]. But then why is (range[0..4], 6) not range[0..6]?
    # But then why is (2,4) not range[2..4]? But I think this would break
    # too much code. So ... it's the same range or the base type. This means
    #  typeof(if b: 0 else 1) == int and not range[0..1]. For now. In the long
    # run people expect ranges to work properly within a tuple.
    if not sameType(a, b):
      result = skipTypes(a, {tyRange}).skipIntLit(c.idgen)
    when false:
      if a.kind != tyRange and b.kind == tyRange:
        # XXX This really needs a better solution, but a proper fix now breaks
        # code.
        result = a #.skipIntLit
      elif a.kind == tyRange and b.kind != tyRange:
        result = b #.skipIntLit
      elif a.kind in IntegralTypes and a.n != nil:
        result = a #.skipIntLit
  else:
    var k = tyNone
    if a.kind in {tyRef, tyPtr}:
      k = a.kind
      if b.kind != a.kind: return x
      # bug #7601, array construction of ptr generic
      a = a.lastSon.skipTypes({tyGenericInst})
      b = b.lastSon.skipTypes({tyGenericInst})
    if a.kind == tyObject and b.kind == tyObject:
      result = commonSuperclass(a, b)
      # this will trigger an error later:
      if result.isNil or result == a: return x
      if result == b: return y
      # bug #7906, tyRef/tyPtr + tyGenericInst of ref/ptr object ->
      # ill-formed AST, no need for additional tyRef/tyPtr
      if k != tyNone and x.kind != tyGenericInst:
        let r = result
        result = newType(k, nextTypeId(c.idgen), r.owner)
        result.addSonSkipIntLit(r, c.idgen)

proc endsInNoReturn(n: PNode): bool =
  # check if expr ends in raise exception or call of noreturn proc
  var it = n
  while it.kind in {nkStmtList, nkStmtListExpr} and it.len > 0:
    it = it.lastSon
  result = it.kind in nkLastBlockStmts or
    it.kind in nkCallKinds and it[0].kind == nkSym and sfNoReturn in it[0].sym.flags

proc commonType*(c: PContext; x: PType, y: PNode): PType =
  # ignore exception raising branches in case/if expressions
  if endsInNoReturn(y): return x
  commonType(c, x, y.typ)

proc newSymS(kind: TSymKind, n: PNode, c: PContext): PSym =
  result = newSym(kind, considerQuotedIdent(c, n), nextSymId c.idgen, getCurrOwner(c), n.info)
  when defined(nimsuggest):
    suggestDecl(c, n, result)

proc newSymG*(kind: TSymKind, n: PNode, c: PContext): PSym =
  # like newSymS, but considers gensym'ed symbols
  if n.kind == nkSym:
    # and sfGenSym in n.sym.flags:
    result = n.sym
    if result.kind notin {kind, skTemp}:
      localError(c.config, n.info, "cannot use symbol of kind '$1' as a '$2'" %
        [result.kind.toHumanStr, kind.toHumanStr])
    when false:
      if sfGenSym in result.flags and result.kind notin {skTemplate, skMacro, skParam}:
        # declarative context, so produce a fresh gensym:
        result = copySym(result)
        result.ast = n.sym.ast
        put(c.p, n.sym, result)
    # when there is a nested proc inside a template, semtmpl
    # will assign a wrong owner during the first pass over the
    # template; we must fix it here: see #909
    result.owner = getCurrOwner(c)
  else:
    result = newSym(kind, considerQuotedIdent(c, n), nextSymId c.idgen, getCurrOwner(c), n.info)
  #if kind in {skForVar, skLet, skVar} and result.owner.kind == skModule:
  #  incl(result.flags, sfGlobal)
  when defined(nimsuggest):
    suggestDecl(c, n, result)

proc semIdentVis(c: PContext, kind: TSymKind, n: PNode,
                 allowed: TSymFlags): PSym
  # identifier with visibility
proc semIdentWithPragma(c: PContext, kind: TSymKind, n: PNode,
                        allowed: TSymFlags): PSym

proc typeAllowedCheck(c: PContext; info: TLineInfo; typ: PType; kind: TSymKind;
                      flags: TTypeAllowedFlags = {}) =
  let t = typeAllowed(typ, kind, c, flags)
  if t != nil:
    var err: string
    if t == typ:
      err = "invalid type: '$1' for $2" % [typeToString(typ), toHumanStr(kind)]
      if kind in {skVar, skLet, skConst} and taIsTemplateOrMacro in flags:
        err &= ". Did you mean to call the $1 with '()'?" % [toHumanStr(typ.owner.kind)]
    else:
      err = "invalid type: '$1' in this context: '$2' for $3" % [typeToString(t),
              typeToString(typ), toHumanStr(kind)]
    localError(c.config, info, err)

proc paramsTypeCheck(c: PContext, typ: PType) {.inline.} =
  typeAllowedCheck(c, typ.n.info, typ, skProc)

proc expectMacroOrTemplateCall(c: PContext, n: PNode): PSym
proc semDirectOp(c: PContext, n: PNode, flags: TExprFlags): PNode
proc semWhen(c: PContext, n: PNode, semCheck: bool = true): PNode
proc semTemplateExpr(c: PContext, n: PNode, s: PSym,
                     flags: TExprFlags = {}): PNode
proc semMacroExpr(c: PContext, n, nOrig: PNode, sym: PSym,
                  flags: TExprFlags = {}): PNode

proc symFromType(c: PContext; t: PType, info: TLineInfo): PSym =
  if t.sym != nil: return t.sym
  result = newSym(skType, getIdent(c.cache, "AnonType"), nextSymId c.idgen, t.owner, info)
  result.flags.incl sfAnon
  result.typ = t

proc symNodeFromType(c: PContext, t: PType, info: TLineInfo): PNode =
  result = newSymNode(symFromType(c, t, info), info)
  result.typ = makeTypeDesc(c, t)

when false:
  proc createEvalContext(c: PContext, mode: TEvalMode): PEvalContext =
    result = newEvalContext(c.module, mode)
    result.getType = proc (n: PNode): PNode =
      result = tryExpr(c, n)
      if result == nil:
        result = newSymNode(errorSym(c, n))
      elif result.typ == nil:
        result = newSymNode(getSysSym"void")
      else:
        result.typ = makeTypeDesc(c, result.typ)

    result.handleIsOperator = proc (n: PNode): PNode =
      result = isOpImpl(c, n)

proc hasCycle(n: PNode): bool =
  incl n.flags, nfNone
  for i in 0..<n.safeLen:
    if nfNone in n[i].flags or hasCycle(n[i]):
      result = true
      break
  excl n.flags, nfNone

proc fixupTypeAfterEval(c: PContext, evaluated, eOrig: PNode): PNode =
  # recompute the types as 'eval' isn't guaranteed to construct types nor
  # that the types are sound:
  when true:
    if eOrig.typ.kind in {tyUntyped, tyTyped, tyTypeDesc}:
      result = semExprWithType(c, evaluated)
    else:
      result = evaluated
      let expectedType = eOrig.typ.skipTypes({tyStatic})
      if hasCycle(result):
        result = localErrorNode(c, eOrig, "the resulting AST is cyclic and cannot be processed further")
      else:
        semmacrosanity.annotateType(result, expectedType, c.config)
  else:
    result = semExprWithType(c, evaluated)
    #result = fitNode(c, e.typ, result) inlined with special case:
    let arg = result
    result = indexTypesMatch(c, eOrig.typ, arg.typ, arg)
    if result == nil:
      result = arg
      # for 'tcnstseq' we support [] to become 'seq'
      if eOrig.typ.skipTypes(abstractInst).kind == tySequence and
         isArrayConstr(arg):
        arg.typ = eOrig.typ

proc tryConstExpr(c: PContext, n: PNode): PNode =
  var e = semExprWithType(c, n)
  if e == nil: return

  result = getConstExpr(c.module, e, c.idgen, c.graph)
  if result != nil: return

  let oldErrorCount = c.config.errorCounter
  let oldErrorMax = c.config.errorMax
  let oldErrorOutputs = c.config.m.errorOutputs

  c.config.m.errorOutputs = {}
  c.config.errorMax = high(int) # `setErrorMaxHighMaybe` not appropriate here

  try:
    result = evalConstExpr(c.module, c.idgen, c.graph, e)
    if result == nil or result.kind == nkEmpty:
      result = nil
    else:
      result = fixupTypeAfterEval(c, result, e)

  except ERecoverableError:
    result = nil

  c.config.errorCounter = oldErrorCount
  c.config.errorMax = oldErrorMax
  c.config.m.errorOutputs = oldErrorOutputs

const
  errConstExprExpected = "constant expression expected"

proc semConstExpr(c: PContext, n: PNode): PNode =
  var e = semExprWithType(c, n)
  if e == nil:
    localError(c.config, n.info, errConstExprExpected)
    return n
  result = getConstExpr(c.module, e, c.idgen, c.graph)
  if result == nil:
    #if e.kind == nkEmpty: globalError(n.info, errConstExprExpected)
    result = evalConstExpr(c.module, c.idgen, c.graph, e)
    if result == nil or result.kind == nkEmpty:
      if e.info != n.info:
        pushInfoContext(c.config, n.info)
        localError(c.config, e.info, errConstExprExpected)
        popInfoContext(c.config)
      else:
        localError(c.config, e.info, errConstExprExpected)
      # error correction:
      result = e
    else:
      result = fixupTypeAfterEval(c, result, e)

proc semExprFlagDispatched(c: PContext, n: PNode, flags: TExprFlags): PNode =
  if efNeedStatic in flags:
    if efPreferNilResult in flags:
      return tryConstExpr(c, n)
    else:
      return semConstExpr(c, n)
  else:
    result = semExprWithType(c, n, flags)
    if efPreferStatic in flags:
      var evaluated = getConstExpr(c.module, result, c.idgen, c.graph)
      if evaluated != nil: return evaluated
      evaluated = evalAtCompileTime(c, result)
      if evaluated != nil: return evaluated

when not defined(nimHasSinkInference):
  {.pragma: nosinks.}

include hlo, seminst, semcall

proc resetSemFlag(n: PNode) =
  excl n.flags, nfSem
  for i in 0..<n.safeLen:
    resetSemFlag(n[i])

proc semAfterMacroCall(c: PContext, call, macroResult: PNode,
                       s: PSym, flags: TExprFlags): PNode =
  ## Semantically check the output of a macro.
  ## This involves processes such as re-checking the macro output for type
  ## coherence, making sure that variables declared with 'let' aren't
  ## reassigned, and binding the unbound identifiers that the macro output
  ## contains.
  inc(c.config.evalTemplateCounter)
  if c.config.evalTemplateCounter > evalTemplateLimit:
    globalError(c.config, s.info, "template instantiation too nested")
  c.friendModules.add(s.owner.getModule)
  result = macroResult
  resetSemFlag result
  if s.typ[0] == nil:
    result = semStmt(c, result, flags)
  else:
    var retType = s.typ[0]
    if retType.kind == tyTypeDesc and tfUnresolved in retType.flags and
        retType.len == 1:
      # bug #11941: template fails(T: type X, v: auto): T
      # does not mean we expect a tyTypeDesc.
      retType = retType[0]
    case retType.kind
    of tyUntyped:
      # Not expecting a type here allows templates like in ``tmodulealias.in``.
      result = semExpr(c, result, flags)
    of tyTyped:
      # More restrictive version.
      result = semExprWithType(c, result, flags)
    of tyTypeDesc:
      if result.kind == nkStmtList: result.transitionSonsKind(nkStmtListType)
      var typ = semTypeNode(c, result, nil)
      if typ == nil:
        localError(c.config, result.info, "expression has no type: " &
                   renderTree(result, {renderNoComments}))
        result = newSymNode(errorSym(c, result))
      else:
        result.typ = makeTypeDesc(c, typ)
      #result = symNodeFromType(c, typ, n.info)
    else:
      if s.ast[genericParamsPos] != nil and retType.isMetaType:
        # The return type may depend on the Macro arguments
        # e.g. template foo(T: typedesc): seq[T]
        # We will instantiate the return type here, because
        # we now know the supplied arguments
        var paramTypes = newIdTable()
        for param, value in genericParamsInMacroCall(s, call):
          idTablePut(paramTypes, param.typ, value.typ)

        retType = generateTypeInstance(c, paramTypes,
                                       macroResult.info, retType)

      result = semExpr(c, result, flags)
      result = fitNode(c, retType, result, result.info)
      #globalError(s.info, errInvalidParamKindX, typeToString(s.typ[0]))
  dec(c.config.evalTemplateCounter)
  discard c.friendModules.pop()

const
  errMissingGenericParamsForTemplate = "'$1' has unspecified generic parameters"
  errFloatToString = "cannot convert '$1' to '$2'"

proc semMacroExpr(c: PContext, n, nOrig: PNode, sym: PSym,
                  flags: TExprFlags = {}): PNode =
  rememberExpansion(c, nOrig.info, sym)
  pushInfoContext(c.config, nOrig.info, sym.detailedInfo)

  let info = getCallLineInfo(n)
  markUsed(c, info, sym)
  onUse(info, sym)
  if sym == c.p.owner:
    globalError(c.config, info, "recursive dependency: '$1'" % sym.name.s)

  let genericParams = sym.ast[genericParamsPos].len
  let suppliedParams = max(n.safeLen - 1, 0)

  if suppliedParams < genericParams:
    globalError(c.config, info, errMissingGenericParamsForTemplate % n.renderTree)

  #if c.evalContext == nil:
  #  c.evalContext = c.createEvalContext(emStatic)
  result = evalMacroCall(c.module, c.idgen, c.graph, c.templInstCounter, n, nOrig, sym)
  if efNoSemCheck notin flags:
    result = semAfterMacroCall(c, n, result, sym, flags)
  if c.config.macrosToExpand.hasKey(sym.name.s):
    message(c.config, nOrig.info, hintExpandMacro, renderTree(result))
  result = wrapInComesFrom(nOrig.info, sym, result)
  popInfoContext(c.config)

proc forceBool(c: PContext, n: PNode): PNode =
  result = fitNode(c, getSysType(c.graph, n.info, tyBool), n, n.info)
  if result == nil: result = n

proc semConstBoolExpr(c: PContext, n: PNode): PNode =
  result = forceBool(c, semConstExpr(c, n))
  if result.kind != nkIntLit:
    localError(c.config, n.info, errConstExprExpected)

proc semGenericStmt(c: PContext, n: PNode): PNode
proc semConceptBody(c: PContext, n: PNode): PNode

include semtypes

proc setGenericParamsMisc(c: PContext; n: PNode) =
  ## used by call defs (procs, templates, macros, ...) to analyse their generic
  ## params, and store the originals in miscPos for better error reporting.
  let orig = n[genericParamsPos]

  doAssert orig.kind in {nkEmpty, nkGenericParams}

  if n[genericParamsPos].kind == nkEmpty:
    n[genericParamsPos] = newNodeI(nkGenericParams, n.info)
  else:
    # we keep the original params around for better error messages, see
    # issue https://github.com/nim-lang/Nim/issues/1713
    n[genericParamsPos] = semGenericParamList(c, orig)

  if n[miscPos].kind == nkEmpty:
    n[miscPos] = newTree(nkBracket, c.graph.emptyNode, orig)
  else:
    n[miscPos][1] = orig

include semtempl, semgnrc, semstmts, semexprs

proc addCodeForGenerics(c: PContext, n: PNode) =
  for i in c.lastGenericIdx..<c.generics.len:
    var prc = c.generics[i].inst.sym
    if prc.kind in {skProc, skFunc, skMethod, skConverter} and prc.magic == mNone:
      if prc.ast == nil or prc.ast[bodyPos] == nil:
        internalError(c.config, prc.info, "no code for " & prc.name.s)
      else:
        n.add prc.ast
  c.lastGenericIdx = c.generics.len

proc myOpen(graph: ModuleGraph; module: PSym; idgen: IdGenerator): PPassContext {.nosinks.} =
  var c = newContext(graph, module)
  c.idgen = idgen
  c.enforceVoidContext = newType(tyTyped, nextTypeId(idgen), nil)
  c.voidType = newType(tyVoid, nextTypeId(idgen), nil)

  if c.p != nil: internalError(graph.config, module.info, "sem.myOpen")
  c.semConstExpr = semConstExpr
  c.semExpr = semExpr
  c.semTryExpr = tryExpr
  c.semTryConstExpr = tryConstExpr
  c.computeRequiresInit = computeRequiresInit
  c.semOperand = semOperand
  c.semConstBoolExpr = semConstBoolExpr
  c.semOverloadedCall = semOverloadedCall
  c.semInferredLambda = semInferredLambda
  c.semGenerateInstance = generateInstance
  c.semTypeNode = semTypeNode
  c.instTypeBoundOp = sigmatch.instTypeBoundOp
  c.hasUnresolvedArgs = hasUnresolvedArgs
  c.templInstCounter = new int

  pushProcCon(c, module)
  pushOwner(c, c.module)

  c.moduleScope = openScope(c)
  c.moduleScope.addSym(module) # a module knows itself

  if sfSystemModule in module.flags:
    graph.systemModule = module
  c.topLevelScope = openScope(c)
  result = c

proc isImportSystemStmt(g: ModuleGraph; n: PNode): bool =
  if g.systemModule == nil: return false
  case n.kind
  of nkImportStmt:
    for x in n:
      if x.kind == nkIdent:
        let f = checkModuleName(g.config, x, false)
        if f == g.systemModule.info.fileIndex:
          return true
  of nkImportExceptStmt, nkFromStmt:
    if n[0].kind == nkIdent:
      let f = checkModuleName(g.config, n[0], false)
      if f == g.systemModule.info.fileIndex:
        return true
  else: discard

proc isEmptyTree(n: PNode): bool =
  case n.kind
  of nkStmtList:
    for it in n:
      if not isEmptyTree(it): return false
    result = true
  of nkEmpty, nkCommentStmt: result = true
  else: result = false

proc semStmtAndGenerateGenerics(c: PContext, n: PNode): PNode =
  if c.topStmts == 0 and not isImportSystemStmt(c.graph, n):
    if sfSystemModule notin c.module.flags and not isEmptyTree(n):
      assert c.graph.systemModule != nil
      c.moduleScope.addSym c.graph.systemModule # import the "System" identifier
      importAllSymbols(c, c.graph.systemModule)
      inc c.topStmts
  else:
    inc c.topStmts
  if sfNoForward in c.module.flags:
    result = semAllTypeSections(c, n)
  else:
    result = n
  result = semStmt(c, result, {})
  when false:
    # Code generators are lazy now and can deal with undeclared procs, so these
    # steps are not required anymore and actually harmful for the upcoming
    # destructor support.
    # BUGFIX: process newly generated generics here, not at the end!
    if c.lastGenericIdx < c.generics.len:
      var a = newNodeI(nkStmtList, n.info)
      addCodeForGenerics(c, a)
      if a.len > 0:
        # a generic has been added to `a`:
        if result.kind != nkEmpty: a.add result
        result = a
  result = hloStmt(c, result)
  if c.config.cmd == cmdInteractive and not isEmptyType(result.typ):
    result = buildEchoStmt(c, result)
  if c.config.cmd == cmdIdeTools:
    appendToModule(c.module, result)
  trackStmt(c, c.module, result, isTopLevel = true)

proc recoverContext(c: PContext) =
  # clean up in case of a semantic error: We clean up the stacks, etc. This is
  # faster than wrapping every stack operation in a 'try finally' block and
  # requires far less code.
  c.currentScope = c.topLevelScope
  while getCurrOwner(c).kind != skModule: popOwner(c)
  while c.p != nil and c.p.owner.kind != skModule: c.p = c.p.next

proc myProcess(context: PPassContext, n: PNode): PNode {.nosinks.} =
  var c = PContext(context)
  # no need for an expensive 'try' if we stop after the first error anyway:
  if c.config.errorMax <= 1:
    result = semStmtAndGenerateGenerics(c, n)
  else:
    let oldContextLen = msgs.getInfoContextLen(c.config)
    let oldInGenericInst = c.inGenericInst
    try:
      result = semStmtAndGenerateGenerics(c, n)
    except ERecoverableError, ESuggestDone:
      recoverContext(c)
      c.inGenericInst = oldInGenericInst
      msgs.setInfoContextLen(c.config, oldContextLen)
      if getCurrentException() of ESuggestDone:
        c.suggestionsMade = true
        result = nil
      else:
        result = newNodeI(nkEmpty, n.info)
      #if c.config.cmd == cmdIdeTools: findSuggest(c, n)
  storeRodNode(c, result)

proc reportUnusedModules(c: PContext) =
  for i in 0..high(c.unusedImports):
    if sfUsed notin c.unusedImports[i][0].flags:
      message(c.config, c.unusedImports[i][1], warnUnusedImportX, c.unusedImports[i][0].name.s)

proc myClose(graph: ModuleGraph; context: PPassContext, n: PNode): PNode =
  var c = PContext(context)
  if c.config.cmd == cmdIdeTools and not c.suggestionsMade:
    suggestSentinel(c)
  closeScope(c)         # close module's scope
  rawCloseScope(c)      # imported symbols; don't check for unused ones!
  reportUnusedModules(c)
  result = newNode(nkStmtList)
  if n != nil:
    internalError(c.config, n.info, "n is not nil") #result := n;
  addCodeForGenerics(c, result)
  if c.module.ast != nil:
    result.add(c.module.ast)
  popOwner(c)
  popProcCon(c)
  sealRodFile(c)

const semPass* = makePass(myOpen, myProcess, myClose,
                          isFrontend = true)
