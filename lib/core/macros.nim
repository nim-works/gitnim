#
#
#            Nim's Runtime Library
#        (c) Copyright 2015 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

include "system/inclrtl"
import std/private/since

## This module contains the interface to the compiler's abstract syntax
## tree (`AST`:idx:). Macros operate on this tree.
##
## See also:
## * `macros tutorial <tut3.html>`_
## * `macros section in Nim manual <manual.html#macros>`_

## .. include:: ../../doc/astspec.txt

# If you look for the implementation of the magic symbol
# ``{.magic: "Foo".}``, search for `mFoo` and `opcFoo`.

type
  NimNodeKind* = enum
    nnkNone, nnkEmpty, nnkIdent, nnkSym,
    nnkType, nnkCharLit, nnkIntLit, nnkInt8Lit,
    nnkInt16Lit, nnkInt32Lit, nnkInt64Lit, nnkUIntLit, nnkUInt8Lit,
    nnkUInt16Lit, nnkUInt32Lit, nnkUInt64Lit, nnkFloatLit,
    nnkFloat32Lit, nnkFloat64Lit, nnkFloat128Lit, nnkStrLit, nnkRStrLit,
    nnkTripleStrLit, nnkNilLit, nnkComesFrom, nnkDotCall,
    nnkCommand, nnkCall, nnkCallStrLit, nnkInfix,
    nnkPrefix, nnkPostfix, nnkHiddenCallConv,
    nnkExprEqExpr,
    nnkExprColonExpr, nnkIdentDefs, nnkVarTuple,
    nnkPar, nnkObjConstr, nnkCurly, nnkCurlyExpr,
    nnkBracket, nnkBracketExpr, nnkPragmaExpr, nnkRange,
    nnkDotExpr, nnkCheckedFieldExpr, nnkDerefExpr, nnkIfExpr,
    nnkElifExpr, nnkElseExpr, nnkLambda, nnkDo, nnkAccQuoted,
    nnkTableConstr, nnkBind,
    nnkClosedSymChoice,
    nnkOpenSymChoice,
    nnkHiddenStdConv,
    nnkHiddenSubConv, nnkConv, nnkCast, nnkStaticExpr,
    nnkAddr, nnkHiddenAddr, nnkHiddenDeref, nnkObjDownConv,
    nnkObjUpConv, nnkChckRangeF, nnkChckRange64, nnkChckRange,
    nnkStringToCString, nnkCStringToString, nnkAsgn,
    nnkFastAsgn, nnkGenericParams, nnkFormalParams, nnkOfInherit,
    nnkImportAs, nnkProcDef, nnkMethodDef, nnkConverterDef,
    nnkMacroDef, nnkTemplateDef, nnkIteratorDef, nnkOfBranch,
    nnkElifBranch, nnkExceptBranch, nnkElse,
    nnkAsmStmt, nnkPragma, nnkPragmaBlock, nnkIfStmt, nnkWhenStmt,
    nnkForStmt, nnkParForStmt, nnkWhileStmt, nnkCaseStmt,
    nnkTypeSection, nnkVarSection, nnkLetSection, nnkConstSection,
    nnkConstDef, nnkTypeDef,
    nnkYieldStmt, nnkDefer, nnkTryStmt, nnkFinally, nnkRaiseStmt,
    nnkReturnStmt, nnkBreakStmt, nnkContinueStmt, nnkBlockStmt, nnkStaticStmt,
    nnkDiscardStmt, nnkStmtList,
    nnkImportStmt,
    nnkImportExceptStmt,
    nnkExportStmt,
    nnkExportExceptStmt,
    nnkFromStmt,
    nnkIncludeStmt,
    nnkBindStmt, nnkMixinStmt, nnkUsingStmt,
    nnkCommentStmt, nnkStmtListExpr, nnkBlockExpr,
    nnkStmtListType, nnkBlockType,
    nnkWith, nnkWithout,
    nnkTypeOfExpr, nnkObjectTy,
    nnkTupleTy, nnkTupleClassTy, nnkTypeClassTy, nnkStaticTy,
    nnkRecList, nnkRecCase, nnkRecWhen,
    nnkRefTy, nnkPtrTy, nnkVarTy,
    nnkConstTy, nnkMutableTy,
    nnkDistinctTy,
    nnkProcTy,
    nnkIteratorTy,         # iterator type
    nnkSharedTy,           # 'shared T'
    nnkEnumTy,
    nnkEnumFieldDef,
    nnkArgList, nnkPattern
    nnkHiddenTryStmt,
    nnkClosure,
    nnkGotoState,
    nnkState,
    nnkBreakState,
    nnkFuncDef,
    nnkTupleConstr,
    nnkError,  ## erroneous AST node

  NimNodeKinds* = set[NimNodeKind]
  NimTypeKind* = enum  # some types are no longer used, see ast.nim
    ntyNone, ntyBool, ntyChar, ntyEmpty,
    ntyAlias, ntyNil, ntyExpr, ntyStmt,
    ntyTypeDesc, ntyGenericInvocation, ntyGenericBody, ntyGenericInst,
    ntyGenericParam, ntyDistinct, ntyEnum, ntyOrdinal,
    ntyArray, ntyObject, ntyTuple, ntySet,
    ntyRange, ntyPtr, ntyRef, ntyVar,
    ntySequence, ntyProc, ntyPointer, ntyOpenArray,
    ntyString, ntyCString, ntyForward, ntyInt,
    ntyInt8, ntyInt16, ntyInt32, ntyInt64,
    ntyFloat, ntyFloat32, ntyFloat64, ntyFloat128,
    ntyUInt, ntyUInt8, ntyUInt16, ntyUInt32, ntyUInt64,
    ntyUnused0, ntyUnused1, ntyUnused2,
    ntyVarargs,
    ntyUncheckedArray,
    ntyError,
    ntyBuiltinTypeClass, ntyUserTypeClass, ntyUserTypeClassInst,
    ntyCompositeTypeClass, ntyInferred, ntyAnd, ntyOr, ntyNot,
    ntyAnything, ntyStatic, ntyFromExpr, ntyOptDeprecated, ntyVoid

  TNimTypeKinds* {.deprecated.} = set[NimTypeKind]
  NimSymKind* = enum
    nskUnknown, nskConditional, nskDynLib, nskParam,
    nskGenericParam, nskTemp, nskModule, nskType, nskVar, nskLet,
    nskConst, nskResult,
    nskProc, nskFunc, nskMethod, nskIterator,
    nskConverter, nskMacro, nskTemplate, nskField,
    nskEnumField, nskForVar, nskLabel,
    nskStub

  TNimSymKinds* {.deprecated.} = set[NimSymKind]

type
  NimIdent* {.deprecated.} = object of RootObj
    ## Represents a Nim identifier in the AST. **Note**: This is only
    ## rarely useful, for identifier construction from a string
    ## use `ident"abc"`.

  NimSymObj = object # hidden
  NimSym* {.deprecated.} = ref NimSymObj
    ## Represents a Nim *symbol* in the compiler; a *symbol* is a looked-up
    ## *ident*.


const
  nnkLiterals* = {nnkCharLit..nnkNilLit}
  nnkCallKinds* = {nnkCall, nnkInfix, nnkPrefix, nnkPostfix, nnkCommand,
                   nnkCallStrLit}
  nnkPragmaCallKinds = {nnkExprColonExpr, nnkCall, nnkCallStrLit}

{.push warnings: off.}

proc toNimIdent*(s: string): NimIdent {.magic: "StrToIdent", noSideEffect, deprecated:
  "Deprecated since version 0.18.0: Use 'ident' or 'newIdentNode' instead.".}
  ## Constructs an identifier from the string `s`.

proc `==`*(a, b: NimIdent): bool {.magic: "EqIdent", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; Use '==' on 'NimNode' instead.".}
  ## Compares two Nim identifiers.

proc `==`*(a, b: NimNode): bool {.magic: "EqNimrodNode", noSideEffect.}
  ## Compare two Nim nodes. Return true if nodes are structurally
  ## equivalent. This means two independently created nodes can be equal.

proc `==`*(a, b: NimSym): bool {.magic: "EqNimrodNode", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; Use '==(NimNode, NimNode)' instead.".}
  ## Compares two Nim symbols.

{.pop.}

proc sameType*(a, b: NimNode): bool {.magic: "SameNodeType", noSideEffect.} =
  ## Compares two Nim nodes' types. Return true if the types are the same,
  ## e.g. true when comparing alias with original type.
  discard

proc len*(n: NimNode): int {.magic: "NLen", noSideEffect.}
  ## Returns the number of children of `n`.

proc `[]`*(n: NimNode, i: int): NimNode {.magic: "NChild", noSideEffect.}
  ## Get `n`'s `i`'th child.

proc `[]`*(n: NimNode, i: BackwardsIndex): NimNode = n[n.len - i.int]
  ## Get `n`'s `i`'th child.

template `^^`(n: NimNode, i: untyped): untyped =
  (when i is BackwardsIndex: n.len - int(i) else: int(i))

proc `[]`*[T, U: Ordinal](n: NimNode, x: HSlice[T, U]): seq[NimNode] =
  ## Slice operation for NimNode.
  ## Returns a seq of child of `n` who inclusive range [n[x.a], n[x.b]].
  let xa = n ^^ x.a
  let L = (n ^^ x.b) - xa + 1
  result = newSeq[NimNode](L)
  for i in 0..<L:
    result[i] = n[i + xa]

proc `[]=`*(n: NimNode, i: int, child: NimNode) {.magic: "NSetChild",
  noSideEffect.}
  ## Set `n`'s `i`'th child to `child`.

proc `[]=`*(n: NimNode, i: BackwardsIndex, child: NimNode) =
  ## Set `n`'s `i`'th child to `child`.
  n[n.len - i.int] = child

template `or`*(x, y: NimNode): NimNode =
  ## Evaluate `x` and when it is not an empty node, return
  ## it. Otherwise evaluate to `y`. Can be used to chain several
  ## expressions to get the first expression that is not empty.
  ##
  ## .. code-block:: nim
  ##
  ##   let node = mightBeEmpty() or mightAlsoBeEmpty() or fallbackNode

  let arg = x
  if arg != nil and arg.kind != nnkEmpty:
    arg
  else:
    y

proc add*(father, child: NimNode): NimNode {.magic: "NAdd", discardable,
  noSideEffect, locks: 0.}
  ## Adds the `child` to the `father` node. Returns the
  ## father node so that calls can be nested.

proc add*(father: NimNode, children: varargs[NimNode]): NimNode {.
  magic: "NAddMultiple", discardable, noSideEffect, locks: 0.}
  ## Adds each child of `children` to the `father` node.
  ## Returns the `father` node so that calls can be nested.

proc del*(father: NimNode, idx = 0, n = 1) {.magic: "NDel", noSideEffect.}
  ## Deletes `n` children of `father` starting at index `idx`.

proc kind*(n: NimNode): NimNodeKind {.magic: "NKind", noSideEffect.}
  ## Returns the `kind` of the node `n`.

proc intVal*(n: NimNode): BiggestInt {.magic: "NIntVal", noSideEffect.}
  ## Returns an integer value from any integer literal or enum field symbol.

proc floatVal*(n: NimNode): BiggestFloat {.magic: "NFloatVal", noSideEffect.}
  ## Returns a float from any floating point literal.


proc symKind*(symbol: NimNode): NimSymKind {.magic: "NSymKind", noSideEffect.}
proc getImpl*(symbol: NimNode): NimNode {.magic: "GetImpl", noSideEffect.}
  ## Returns a copy of the declaration of a symbol or `nil`.
proc strVal*(n: NimNode): string  {.magic: "NStrVal", noSideEffect.}
  ## Returns the string value of an identifier, symbol, comment, or string literal.
  ##
  ## See also:
  ## * `strVal= proc<#strVal=,NimNode,string>`_ for setting the string value.

{.push warnings: off.} # silence `deprecated`

proc ident*(n: NimNode): NimIdent {.magic: "NIdent", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; All functionality is defined on 'NimNode'.".}

proc symbol*(n: NimNode): NimSym {.magic: "NSymbol", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; All functionality is defined on 'NimNode'.".}

proc getImpl*(s: NimSym): NimNode {.magic: "GetImpl", noSideEffect, deprecated: "use `getImpl: NimNode -> NimNode` instead".}

proc `$`*(i: NimIdent): string {.magic: "NStrVal", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; Use 'strVal' instead.".}
  ## Converts a Nim identifier to a string.

proc `$`*(s: NimSym): string {.magic: "NStrVal", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; Use 'strVal' instead.".}
  ## Converts a Nim symbol to a string.

{.pop.}

when (NimMajor, NimMinor, NimPatch) >= (1, 3, 5) or defined(nimSymImplTransform):
  proc getImplTransformed*(symbol: NimNode): NimNode {.magic: "GetImplTransf", noSideEffect.}
    ## For a typed proc returns the AST after transformation pass; this is useful
    ## for debugging how the compiler transforms code (e.g.: `defer`, `for`) but
    ## note that code transformations are implementation dependent and subject to change.
    ## See an example in `tests/macros/tmacros_various.nim`.

proc owner*(sym: NimNode): NimNode {.magic: "SymOwner", noSideEffect.}
  ## Accepts a node of kind `nnkSym` and returns its owner's symbol.
  ## The meaning of 'owner' depends on `sym`'s `NimSymKind` and declaration
  ## context. For top level declarations this is an `nskModule` symbol,
  ## for proc local variables an `nskProc` symbol, for enum/object fields an
  ## `nskType` symbol, etc. For symbols without an owner, `nil` is returned.
  ##
  ## See also:
  ## * `symKind proc<#symKind,NimNode>`_ to get the kind of a symbol
  ## * `getImpl proc<#getImpl,NimNode>`_ to get the declaration of a symbol

proc isInstantiationOf*(instanceProcSym, genProcSym: NimNode): bool {.magic: "SymIsInstantiationOf", noSideEffect.}
  ## Checks if a proc symbol is an instance of the generic proc symbol.
  ## Useful to check proc symbols against generic symbols
  ## returned by `bindSym`.

proc getType*(n: NimNode): NimNode {.magic: "NGetType", noSideEffect.}
  ## With 'getType' you can access the node's `type`:idx:. A Nim type is
  ## mapped to a Nim AST too, so it's slightly confusing but it means the same
  ## API can be used to traverse types. Recursive types are flattened for you
  ## so there is no danger of infinite recursions during traversal. To
  ## resolve recursive types, you have to call 'getType' again. To see what
  ## kind of type it is, call `typeKind` on getType's result.

proc getType*(n: typedesc): NimNode {.magic: "NGetType", noSideEffect.}
  ## Version of `getType` which takes a `typedesc`.

proc typeKind*(n: NimNode): NimTypeKind {.magic: "NGetType", noSideEffect.}
  ## Returns the type kind of the node 'n' that should represent a type, that
  ## means the node should have been obtained via `getType`.

proc getTypeInst*(n: NimNode): NimNode {.magic: "NGetType", noSideEffect.} =
  ## Returns the `type`:idx: of a node in a form matching the way the
  ## type instance was declared in the code.
  runnableExamples:
    type
      Vec[N: static[int], T] = object
        arr: array[N, T]
      Vec4[T] = Vec[4, T]
      Vec4f = Vec4[float32]
    var a: Vec4f
    var b: Vec4[float32]
    var c: Vec[4, float32]
    macro dumpTypeInst(x: typed): untyped =
      newLit(x.getTypeInst.repr)
    doAssert(dumpTypeInst(a) == "Vec4f")
    doAssert(dumpTypeInst(b) == "Vec4[float32]")
    doAssert(dumpTypeInst(c) == "Vec[4, float32]")

proc getTypeInst*(n: typedesc): NimNode {.magic: "NGetType", noSideEffect.}
  ## Version of `getTypeInst` which takes a `typedesc`.

proc getTypeImpl*(n: NimNode): NimNode {.magic: "NGetType", noSideEffect.} =
  ## Returns the `type`:idx: of a node in a form matching the implementation
  ## of the type. Any intermediate aliases are expanded to arrive at the final
  ## type implementation. You can instead use `getImpl` on a symbol if you
  ## want to find the intermediate aliases.
  runnableExamples:
    type
      Vec[N: static[int], T] = object
        arr: array[N, T]
      Vec4[T] = Vec[4, T]
      Vec4f = Vec4[float32]
    var a: Vec4f
    var b: Vec4[float32]
    var c: Vec[4, float32]
    macro dumpTypeImpl(x: typed): untyped =
      newLit(x.getTypeImpl.repr)
    let t = """
object
  arr: array[0 .. 3, float32]
"""
    doAssert(dumpTypeImpl(a) == t)
    doAssert(dumpTypeImpl(b) == t)
    doAssert(dumpTypeImpl(c) == t)

proc signatureHash*(n: NimNode): string {.magic: "NSigHash", noSideEffect.}
  ## Returns a stable identifier derived from the signature of a symbol.
  ## The signature combines many factors such as the type of the symbol,
  ## the owning module of the symbol and others. The same identifier is
  ## used in the back-end to produce the mangled symbol name.

proc symBodyHash*(s: NimNode): string {.noSideEffect.} =
  ## Returns a stable digest for symbols derived not only from type signature
  ## and owning module, but also implementation body. All procs/variables used in
  ## the implementation of this symbol are hashed recursively as well, including
  ## magics from system module.
  discard

proc getTypeImpl*(n: typedesc): NimNode {.magic: "NGetType", noSideEffect.}
  ## Version of `getTypeImpl` which takes a `typedesc`.

proc `intVal=`*(n: NimNode, val: BiggestInt) {.magic: "NSetIntVal", noSideEffect.}
proc `floatVal=`*(n: NimNode, val: BiggestFloat) {.magic: "NSetFloatVal", noSideEffect.}

{.push warnings: off.}

proc `symbol=`*(n: NimNode, val: NimSym) {.magic: "NSetSymbol", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; Generate a new 'NimNode' with 'genSym' instead.".}

proc `ident=`*(n: NimNode, val: NimIdent) {.magic: "NSetIdent", noSideEffect, deprecated:
  "Deprecated since version 0.18.1; Generate a new 'NimNode' with 'ident(string)' instead.".}

{.pop.}

proc `strVal=`*(n: NimNode, val: string) {.magic: "NSetStrVal", noSideEffect.}
  ## Sets the string value of a string literal or comment.
  ## Setting `strVal` is disallowed for `nnkIdent` and `nnkSym` nodes; a new node
  ## must be created using `ident` or `bindSym` instead.
  ##
  ## See also:
  ## * `strVal proc<#strVal,NimNode>`_ for getting the string value.
  ## * `ident proc<#ident,string>`_ for creating an identifier.
  ## * `bindSym proc<#bindSym%2C%2CBindSymRule>`_ for binding a symbol.

proc newNimNode*(kind: NimNodeKind,
                 lineInfoFrom: NimNode = nil): NimNode
  {.magic: "NNewNimNode", noSideEffect.}
  ## Creates a new AST node of the specified kind.
  ##
  ## The `lineInfoFrom` parameter is used for line information when the
  ## produced code crashes. You should ensure that it is set to a node that
  ## you are transforming.

proc copyNimNode*(n: NimNode): NimNode {.magic: "NCopyNimNode", noSideEffect.}
proc copyNimTree*(n: NimNode): NimNode {.magic: "NCopyNimTree", noSideEffect.}

proc error*(msg: string, n: NimNode = nil) {.magic: "NError", benign.}
  ## Writes an error message at compile time. The optional `n: NimNode`
  ## parameter is used as the source for file and line number information in
  ## the compilation error message.

proc warning*(msg: string, n: NimNode = nil) {.magic: "NWarning", benign.}
  ## Writes a warning message at compile time.

proc hint*(msg: string, n: NimNode = nil) {.magic: "NHint", benign.}
  ## Writes a hint message at compile time.

proc newStrLitNode*(s: string): NimNode {.noSideEffect.} =
  ## Creates a string literal node from `s`.
  result = newNimNode(nnkStrLit)
  result.strVal = s

proc newCommentStmtNode*(s: string): NimNode {.noSideEffect.} =
  ## Creates a comment statement node.
  result = newNimNode(nnkCommentStmt)
  result.strVal = s

proc newIntLitNode*(i: BiggestInt): NimNode =
  ## Creates an int literal node from `i`.
  result = newNimNode(nnkIntLit)
  result.intVal = i

proc newFloatLitNode*(f: BiggestFloat): NimNode =
  ## Creates a float literal node from `f`.
  result = newNimNode(nnkFloatLit)
  result.floatVal = f

{.push warnings: off.}

proc newIdentNode*(i: NimIdent): NimNode {.deprecated: "use ident(string)".} =
  ## Creates an identifier node from `i`.
  result = newNimNode(nnkIdent)
  result.ident = i

{.pop.}

proc newIdentNode*(i: string): NimNode {.magic: "StrToIdent", noSideEffect.}
  ## Creates an identifier node from `i`. It is simply an alias for
  ## `ident(string)`. Use that, it's shorter.

proc ident*(name: string): NimNode {.magic: "StrToIdent", noSideEffect.}
  ## Create a new ident node from a string.

type
  BindSymRule* = enum    ## specifies how `bindSym` behaves
    brClosed,            ## only the symbols in current scope are bound
    brOpen,              ## open wrt overloaded symbols, but may be a single
                         ## symbol if not ambiguous (the rules match that of
                         ## binding in generics)
    brForceOpen          ## same as brOpen, but it will always be open even
                         ## if not ambiguous (this cannot be achieved with
                         ## any other means in the language currently)

proc bindSym*(ident: string | NimNode, rule: BindSymRule = brClosed): NimNode {.
              magic: "NBindSym", noSideEffect.}
  ## Creates a node that binds `ident` to a symbol node. The bound symbol
  ## may be an overloaded symbol.
  ## if `ident` is a NimNode, it must have `nnkIdent` kind.
  ## If `rule == brClosed` either an `nnkClosedSymChoice` tree is
  ## returned or `nnkSym` if the symbol is not ambiguous.
  ## If `rule == brOpen` either an `nnkOpenSymChoice` tree is
  ## returned or `nnkSym` if the symbol is not ambiguous.
  ## If `rule == brForceOpen` always an `nnkOpenSymChoice` tree is
  ## returned even if the symbol is not ambiguous.
  ##
  ## Experimental feature:
  ## use {.experimental: "dynamicBindSym".} to activate it.
  ## If called from template / regular code, `ident` and `rule` must be
  ## constant expression / literal value.
  ## If called from macros / compile time procs / static blocks,
  ## `ident` and `rule` can be VM computed value.

proc genSym*(kind: NimSymKind = nskLet; ident = ""): NimNode {.
  magic: "NGenSym", noSideEffect.}
  ## Generates a fresh symbol that is guaranteed to be unique. The symbol
  ## needs to occur in a declaration context.

proc callsite*(): NimNode {.magic: "NCallSite", benign, deprecated:
  "Deprecated since v0.18.1; use `varargs[untyped]` in the macro prototype instead".}
  ## Returns the AST of the invocation expression that invoked this macro.
  # see https://github.com/nim-lang/RFCs/issues/387 as candidate replacement.

proc toStrLit*(n: NimNode): NimNode =
  ## Converts the AST `n` to the concrete Nim code and wraps that
  ## in a string literal node.
  return newStrLitNode(repr(n))

type
  LineInfo* = object
    filename*: string
    line*,column*: int

proc `$`*(arg: LineInfo): string =
  ## Return a string representation in the form `filepath(line, column)`.
  # BUG: without `result = `, gives compile error
  result = arg.filename & "(" & $arg.line & ", " & $arg.column & ")"

#proc lineinfo*(n: NimNode): LineInfo {.magic: "NLineInfo", noSideEffect.}
#  ## returns the position the node appears in the original source file
#  ## in the form filename(line, col)

proc getLine(arg: NimNode): int {.magic: "NLineInfo", noSideEffect.}
proc getColumn(arg: NimNode): int {.magic: "NLineInfo", noSideEffect.}
proc getFile(arg: NimNode): string {.magic: "NLineInfo", noSideEffect.}

proc copyLineInfo*(arg: NimNode, info: NimNode) {.magic: "NLineInfo", noSideEffect.}
  ## Copy lineinfo from `info`.

proc lineInfoObj*(n: NimNode): LineInfo =
  ## Returns `LineInfo` of `n`, using absolute path for `filename`.
  result = LineInfo(filename: n.getFile, line: n.getLine, column: n.getColumn)

proc lineInfo*(arg: NimNode): string =
  ## Return line info in the form `filepath(line, column)`.
  $arg.lineInfoObj

proc internalParseExpr(s: string): NimNode {.
  magic: "ParseExprToAst", noSideEffect.}

proc internalParseStmt(s: string): NimNode {.
  magic: "ParseStmtToAst", noSideEffect.}

proc internalErrorFlag*(): string {.magic: "NError", noSideEffect.}
  ## Some builtins set an error flag. This is then turned into a proper
  ## exception. **Note**: Ordinary application code should not call this.

proc parseExpr*(s: string): NimNode {.noSideEffect.} =
  ## Compiles the passed string to its AST representation.
  ## Expects a single expression. Raises `ValueError` for parsing errors.
  result = internalParseExpr(s)
  let x = internalErrorFlag()
  if x.len > 0: raise newException(ValueError, x)

proc parseStmt*(s: string): NimNode {.noSideEffect.} =
  ## Compiles the passed string to its AST representation.
  ## Expects one or more statements. Raises `ValueError` for parsing errors.
  result = internalParseStmt(s)
  let x = internalErrorFlag()
  if x.len > 0: raise newException(ValueError, x)

proc getAst*(macroOrTemplate: untyped): NimNode {.magic: "ExpandToAst", noSideEffect.}
  ## Obtains the AST nodes returned from a macro or template invocation.
  ## See also `genasts.genAst`.
  ## Example:
  ##
  ## .. code-block:: nim
  ##
  ##   macro FooMacro() =
  ##     var ast = getAst(BarTemplate())

proc quote*(bl: typed, op = "``"): NimNode {.magic: "QuoteAst", noSideEffect.} =
  ## Quasi-quoting operator.
  ## Accepts an expression or a block and returns the AST that represents it.
  ## Within the quoted AST, you are able to interpolate NimNode expressions
  ## from the surrounding scope. If no operator is given, quoting is done using
  ## backticks. Otherwise, the given operator must be used as a prefix operator
  ## for any interpolated expression. The original meaning of the interpolation
  ## operator may be obtained by escaping it (by prefixing it with itself) when used
  ## as a unary operator:
  ## e.g. `@` is escaped as `@@`, `&%` is escaped as `&%&%` and so on; see examples.
  ##
  ## A custom operator interpolation needs accent quoted (``) whenever it resolves
  ## to a symbol.
  ##
  ## See also `genasts <genasts.html>`_ which avoids some issues with `quote`.
  runnableExamples:
    macro check(ex: untyped) =
      # this is a simplified version of the check macro from the
      # unittest module.

      # If there is a failed check, we want to make it easy for
      # the user to jump to the faulty line in the code, so we
      # get the line info here:
      var info = ex.lineinfo

      # We will also display the code string of the failed check:
      var expString = ex.toStrLit

      # Finally we compose the code to implement the check:
      result = quote do:
        if not `ex`:
          echo `info` & ": Check failed: " & `expString`
    check 1 + 1 == 2

  runnableExamples:
    # example showing how to define a symbol that requires backtick without
    # quoting it.
    var destroyCalled = false
    macro bar() =
      let s = newTree(nnkAccQuoted, ident"=destroy")
      # let s = ident"`=destroy`" # this would not work
      result = quote do:
        type Foo = object
        # proc `=destroy`(a: var Foo) = destroyCalled = true # this would not work
        proc `s`(a: var Foo) = destroyCalled = true
        block:
          let a = Foo()
    bar()
    doAssert destroyCalled

  runnableExamples:
    # custom `op`
    var destroyCalled = false
    macro bar(ident) =
      var x = 1.5
      result = quote("@") do:
        type Foo = object
        let `@ident` = 0 # custom op interpolated symbols need quoted (``)
        proc `=destroy`(a: var Foo) =
          doAssert @x == 1.5
          doAssert compiles(@x == 1.5)
          let b1 = @[1,2]
          let b2 = @@[1,2]
          doAssert $b1 == "[1, 2]"
          doAssert $b2 == "@[1, 2]"
          destroyCalled = true
        block:
          let a = Foo()
    bar(someident)
    doAssert destroyCalled

    proc `&%`(x: int): int = 1
    proc `&%`(x, y: int): int = 2

    macro bar2() =
      var x = 3
      result = quote("&%") do:
        var y = &%x # quoting operator
        doAssert &%&%y == 1 # unary operator => need to escape
        doAssert y &% y == 2 # binary operator => no need to escape
        doAssert y == 3
    bar2()

proc expectKind*(n: NimNode, k: NimNodeKind) =
  ## Checks that `n` is of kind `k`. If this is not the case,
  ## compilation aborts with an error message. This is useful for writing
  ## macros that check the AST that is passed to them.
  if n.kind != k: error("Expected a node of kind " & $k & ", got " & $n.kind, n)

proc expectMinLen*(n: NimNode, min: int) =
  ## Checks that `n` has at least `min` children. If this is not the case,
  ## compilation aborts with an error message. This is useful for writing
  ## macros that check its number of arguments.
  if n.len < min: error("Expected a node with at least " & $min & " children, got " & $n.len, n)

proc expectLen*(n: NimNode, len: int) =
  ## Checks that `n` has exactly `len` children. If this is not the case,
  ## compilation aborts with an error message. This is useful for writing
  ## macros that check its number of arguments.
  if n.len != len: error("Expected a node with " & $len & " children, got " & $n.len, n)

proc expectLen*(n: NimNode, min, max: int) =
  ## Checks that `n` has a number of children in the range `min..max`.
  ## If this is not the case, compilation aborts with an error message.
  ## This is useful for writing macros that check its number of arguments.
  if n.len < min or n.len > max:
    error("Expected a node with " & $min & ".." & $max & " children, got " & $n.len, n)

proc newTree*(kind: NimNodeKind,
              children: varargs[NimNode]): NimNode =
  ## Produces a new node with children.
  result = newNimNode(kind)
  result.add(children)

proc newCall*(theProc: NimNode, args: varargs[NimNode]): NimNode =
  ## Produces a new call node. `theProc` is the proc that is called with
  ## the arguments `args[0..]`.
  result = newNimNode(nnkCall)
  result.add(theProc)
  result.add(args)

{.push warnings: off.}

proc newCall*(theProc: NimIdent, args: varargs[NimNode]): NimNode {.deprecated:
  "Deprecated since v0.18.1; use 'newCall(string, ...)' or 'newCall(NimNode, ...)' instead".} =
  ## Produces a new call node. `theProc` is the proc that is called with
  ## the arguments `args[0..]`.
  result = newNimNode(nnkCall)
  result.add(newIdentNode(theProc))
  result.add(args)

{.pop.}

proc newCall*(theProc: string,
              args: varargs[NimNode]): NimNode =
  ## Produces a new call node. `theProc` is the proc that is called with
  ## the arguments `args[0..]`.
  result = newNimNode(nnkCall)
  result.add(newIdentNode(theProc))
  result.add(args)

proc newLit*(c: char): NimNode =
  ## Produces a new character literal node.
  result = newNimNode(nnkCharLit)
  result.intVal = ord(c)

proc newLit*(i: int): NimNode =
  ## Produces a new integer literal node.
  result = newNimNode(nnkIntLit)
  result.intVal = i

proc newLit*(i: int8): NimNode =
  ## Produces a new integer literal node.
  result = newNimNode(nnkInt8Lit)
  result.intVal = i

proc newLit*(i: int16): NimNode =
  ## Produces a new integer literal node.
  result = newNimNode(nnkInt16Lit)
  result.intVal = i

proc newLit*(i: int32): NimNode =
  ## Produces a new integer literal node.
  result = newNimNode(nnkInt32Lit)
  result.intVal = i

proc newLit*(i: int64): NimNode =
  ## Produces a new integer literal node.
  result = newNimNode(nnkInt64Lit)
  result.intVal = i

proc newLit*(i: uint): NimNode =
  ## Produces a new unsigned integer literal node.
  result = newNimNode(nnkUIntLit)
  result.intVal = BiggestInt(i)

proc newLit*(i: uint8): NimNode =
  ## Produces a new unsigned integer literal node.
  result = newNimNode(nnkUInt8Lit)
  result.intVal = BiggestInt(i)

proc newLit*(i: uint16): NimNode =
  ## Produces a new unsigned integer literal node.
  result = newNimNode(nnkUInt16Lit)
  result.intVal = BiggestInt(i)

proc newLit*(i: uint32): NimNode =
  ## Produces a new unsigned integer literal node.
  result = newNimNode(nnkUInt32Lit)
  result.intVal = BiggestInt(i)

proc newLit*(i: uint64): NimNode =
  ## Produces a new unsigned integer literal node.
  result = newNimNode(nnkUInt64Lit)
  result.intVal = BiggestInt(i)

proc newLit*(b: bool): NimNode =
  ## Produces a new boolean literal node.
  result = if b: bindSym"true" else: bindSym"false"

proc newLit*(s: string): NimNode =
  ## Produces a new string literal node.
  result = newNimNode(nnkStrLit)
  result.strVal = s

when false:
  # the float type is not really a distinct type as described in https://github.com/nim-lang/Nim/issues/5875
  proc newLit*(f: float): NimNode =
    ## Produces a new float literal node.
    result = newNimNode(nnkFloatLit)
    result.floatVal = f

proc newLit*(f: float32): NimNode =
  ## Produces a new float literal node.
  result = newNimNode(nnkFloat32Lit)
  result.floatVal = f

proc newLit*(f: float64): NimNode =
  ## Produces a new float literal node.
  result = newNimNode(nnkFloat64Lit)
  result.floatVal = f

when declared(float128):
  proc newLit*(f: float128): NimNode =
    ## Produces a new float literal node.
    result = newNimNode(nnkFloat128Lit)
    result.floatVal = f

proc newLit*(arg: enum): NimNode =
  result = newCall(
    arg.typeof.getTypeInst[1],
    newLit(int(arg))
  )

proc newLit*[N,T](arg: array[N,T]): NimNode
proc newLit*[T](arg: seq[T]): NimNode
proc newLit*[T](s: set[T]): NimNode
proc newLit*[T: tuple](arg: T): NimNode

proc newLit*(arg: object): NimNode =
  result = nnkObjConstr.newTree(arg.typeof.getTypeInst[1])
  for a, b in arg.fieldPairs:
    result.add nnkExprColonExpr.newTree( newIdentNode(a), newLit(b) )

proc newLit*(arg: ref object): NimNode =
  ## produces a new ref type literal node.
  result = nnkObjConstr.newTree(arg.typeof.getTypeInst[1])
  for a, b in fieldPairs(arg[]):
    result.add nnkExprColonExpr.newTree(newIdentNode(a), newLit(b))

proc newLit*[N,T](arg: array[N,T]): NimNode =
  result = nnkBracket.newTree
  for x in arg:
    result.add newLit(x)

proc newLit*[T](arg: seq[T]): NimNode =
  let bracket = nnkBracket.newTree
  for x in arg:
    bracket.add newLit(x)
  result = nnkPrefix.newTree(
    bindSym"@",
    bracket
  )
  if arg.len == 0:
    # add type cast for empty seq
    var typ = getTypeInst(typeof(arg))[1]
    result = newCall(typ,result)

proc newLit*[T](s: set[T]): NimNode =
  result = nnkCurly.newTree
  for x in s:
    result.add newLit(x)
  if result.len == 0:
    # add type cast for empty set
    var typ = getTypeInst(typeof(s))[1]
    result = newCall(typ,result)

proc isNamedTuple(T: typedesc): bool {.magic: "TypeTrait".}
  ## See `typetraits.isNamedTuple`

proc newLit*[T: tuple](arg: T): NimNode =
  ## use -d:nimHasWorkaround14720 to restore behavior prior to PR, forcing
  ## a named tuple even when `arg` is unnamed.
  result = nnkTupleConstr.newTree
  when defined(nimHasWorkaround14720) or isNamedTuple(T):
    for a, b in arg.fieldPairs:
      result.add nnkExprColonExpr.newTree(newIdentNode(a), newLit(b))
  else:
    for b in arg.fields:
      result.add newLit(b)

proc nestList*(op: NimNode; pack: NimNode): NimNode =
  ## Nests the list `pack` into a tree of call expressions:
  ## `[a, b, c]` is transformed into `op(a, op(c, d))`.
  ## This is also known as fold expression.
  if pack.len < 1:
    error("`nestList` expects a node with at least 1 child")
  result = pack[^1]
  for i in countdown(pack.len - 2, 0):
    result = newCall(op, pack[i], result)

proc nestList*(op: NimNode; pack: NimNode; init: NimNode): NimNode =
  ## Nests the list `pack` into a tree of call expressions:
  ## `[a, b, c]` is transformed into `op(a, op(c, d))`.
  ## This is also known as fold expression.
  result = init
  for i in countdown(pack.len - 1, 0):
    result = newCall(op, pack[i], result)

proc eqIdent*(a: string; b: string): bool {.magic: "EqIdent", noSideEffect.}
  ## Style insensitive comparison.

proc eqIdent*(a: NimNode; b: string): bool {.magic: "EqIdent", noSideEffect.}
  ## Style insensitive comparison.  `a` can be an identifier or a
  ## symbol. `a` may be wrapped in an export marker
  ## (`nnkPostfix`) or quoted with backticks (`nnkAccQuoted`),
  ## these nodes will be unwrapped.

proc eqIdent*(a: string; b: NimNode): bool {.magic: "EqIdent", noSideEffect.}
  ## Style insensitive comparison.  `b` can be an identifier or a
  ## symbol. `b` may be wrapped in an export marker
  ## (`nnkPostfix`) or quoted with backticks (`nnkAccQuoted`),
  ## these nodes will be unwrapped.

proc eqIdent*(a: NimNode; b: NimNode): bool {.magic: "EqIdent", noSideEffect.}
  ## Style insensitive comparison.  `a` and `b` can be an
  ## identifier or a symbol. Both may be wrapped in an export marker
  ## (`nnkPostfix`) or quoted with backticks (`nnkAccQuoted`),
  ## these nodes will be unwrapped.

const collapseSymChoice = not defined(nimLegacyMacrosCollapseSymChoice)

proc treeTraverse(n: NimNode; res: var string; level = 0; isLisp = false, indented = false) {.benign.} =
  if level > 0:
    if indented:
      res.add("\n")
      for i in 0 .. level-1:
        if isLisp:
          res.add(" ")          # dumpLisp indentation
        else:
          res.add("  ")         # dumpTree indentation
    else:
      res.add(" ")

  if isLisp:
    res.add("(")
  res.add(($n.kind).substr(3))

  case n.kind
  of nnkEmpty, nnkNilLit:
    discard # same as nil node in this representation
  of nnkCharLit .. nnkInt64Lit:
    res.add(" " & $n.intVal)
  of nnkFloatLit .. nnkFloat64Lit:
    res.add(" " & $n.floatVal)
  of nnkStrLit .. nnkTripleStrLit, nnkCommentStmt, nnkIdent, nnkSym:
    res.add(" " & $n.strVal.newLit.repr)
  of nnkNone:
    assert false
  elif n.kind in {nnkOpenSymChoice, nnkClosedSymChoice} and collapseSymChoice:
    res.add(" " & $n.len)
    if n.len > 0:
      var allSameSymName = true
      for i in 0..<n.len:
        if n[i].kind != nnkSym or not eqIdent(n[i], n[0]):
          allSameSymName = false
          break
      if allSameSymName:
        res.add(" " & $n[0].strVal.newLit.repr)
      else:
        for j in 0 ..< n.len:
          n[j].treeTraverse(res, level+1, isLisp, indented)
  else:
    for j in 0 ..< n.len:
      n[j].treeTraverse(res, level+1, isLisp, indented)

  if isLisp:
    res.add(")")

proc treeRepr*(n: NimNode): string {.benign.} =
  ## Convert the AST `n` to a human-readable tree-like string.
  ##
  ## See also `repr`, `lispRepr`, and `astGenRepr`.
  result = ""
  n.treeTraverse(result, isLisp = false, indented = true)

proc lispRepr*(n: NimNode; indented = false): string {.benign.} =
  ## Convert the AST `n` to a human-readable lisp-like string.
  ##
  ## See also `repr`, `treeRepr`, and `astGenRepr`.
  result = ""
  n.treeTraverse(result, isLisp = true, indented = indented)

proc astGenRepr*(n: NimNode): string {.benign.} =
  ## Convert the AST `n` to the code required to generate that AST.
  ##
  ## See also `repr`, `treeRepr`, and `lispRepr`.

  const
    NodeKinds = {nnkEmpty, nnkIdent, nnkSym, nnkNone, nnkCommentStmt}
    LitKinds = {nnkCharLit..nnkInt64Lit, nnkFloatLit..nnkFloat64Lit, nnkStrLit..nnkTripleStrLit}

  proc traverse(res: var string, level: int, n: NimNode) {.benign.} =
    for i in 0..level-1: res.add "  "
    if n.kind in NodeKinds:
      res.add("new" & ($n.kind).substr(3) & "Node(")
    elif n.kind in LitKinds:
      res.add("newLit(")
    elif n.kind == nnkNilLit:
      res.add("newNilLit()")
    else:
      res.add($n.kind)

    case n.kind
    of nnkEmpty, nnkNilLit: discard
    of nnkCharLit: res.add("'" & $chr(n.intVal) & "'")
    of nnkIntLit..nnkInt64Lit: res.add($n.intVal)
    of nnkFloatLit..nnkFloat64Lit: res.add($n.floatVal)
    of nnkStrLit..nnkTripleStrLit, nnkCommentStmt, nnkIdent, nnkSym:
      res.add(n.strVal.newLit.repr)
    of nnkNone: assert false
    elif n.kind in {nnkOpenSymChoice, nnkClosedSymChoice} and collapseSymChoice:
      res.add(", # unrepresentable symbols: " & $n.len)
      if n.len > 0:
        res.add(" " & n[0].strVal.newLit.repr)
    else:
      res.add(".newTree(")
      for j in 0..<n.len:
        res.add "\n"
        traverse(res, level + 1, n[j])
        if j != n.len-1:
          res.add(",")

      res.add("\n")
      for i in 0..level-1: res.add "  "
      res.add(")")

    if n.kind in NodeKinds+LitKinds:
      res.add(")")

  result = ""
  traverse(result, 0, n)

macro dumpTree*(s: untyped): untyped = echo s.treeRepr
  ## Accepts a block of nim code and prints the parsed abstract syntax
  ## tree using the `treeRepr` proc. Printing is done *at compile time*.
  ##
  ## You can use this as a tool to explore the Nim's abstract syntax
  ## tree and to discover what kind of nodes must be created to represent
  ## a certain expression/statement.
  ##
  ## For example:
  ##
  ## .. code-block:: nim
  ##    dumpTree:
  ##      echo "Hello, World!"
  ##
  ## Outputs:
  ##
  ## .. code-block::
  ##    StmtList
  ##      Command
  ##        Ident "echo"
  ##        StrLit "Hello, World!"
  ##
  ## Also see `dumpAstGen` and `dumpLisp`.

macro dumpLisp*(s: untyped): untyped = echo s.lispRepr(indented = true)
  ## Accepts a block of nim code and prints the parsed abstract syntax
  ## tree using the `lispRepr` proc. Printing is done *at compile time*.
  ##
  ## You can use this as a tool to explore the Nim's abstract syntax
  ## tree and to discover what kind of nodes must be created to represent
  ## a certain expression/statement.
  ##
  ## For example:
  ##
  ## .. code-block:: nim
  ##    dumpLisp:
  ##      echo "Hello, World!"
  ##
  ## Outputs:
  ##
  ## .. code-block::
  ##    (StmtList
  ##     (Command
  ##      (Ident "echo")
  ##      (StrLit "Hello, World!")))
  ##
  ## Also see `dumpAstGen` and `dumpTree`.

macro dumpAstGen*(s: untyped): untyped = echo s.astGenRepr
  ## Accepts a block of nim code and prints the parsed abstract syntax
  ## tree using the `astGenRepr` proc. Printing is done *at compile time*.
  ##
  ## You can use this as a tool to write macros quicker by writing example
  ## outputs and then copying the snippets into the macro for modification.
  ##
  ## For example:
  ##
  ## .. code-block:: nim
  ##    dumpAstGen:
  ##      echo "Hello, World!"
  ##
  ## Outputs:
  ##
  ## .. code-block:: nim
  ##    nnkStmtList.newTree(
  ##      nnkCommand.newTree(
  ##        newIdentNode("echo"),
  ##        newLit("Hello, World!")
  ##      )
  ##    )
  ##
  ## Also see `dumpTree` and `dumpLisp`.

proc newEmptyNode*(): NimNode {.noSideEffect.} =
  ## Create a new empty node.
  result = newNimNode(nnkEmpty)

proc newStmtList*(stmts: varargs[NimNode]): NimNode=
  ## Create a new statement list.
  result = newNimNode(nnkStmtList).add(stmts)

proc newPar*(exprs: varargs[NimNode]): NimNode=
  ## Create a new parentheses-enclosed expression.
  newNimNode(nnkPar).add(exprs)

proc newBlockStmt*(label, body: NimNode): NimNode =
  ## Create a new block statement with label.
  return newNimNode(nnkBlockStmt).add(label, body)

proc newBlockStmt*(body: NimNode): NimNode =
  ## Create a new block: stmt.
  return newNimNode(nnkBlockStmt).add(newEmptyNode(), body)

proc newVarStmt*(name, value: NimNode): NimNode =
  ## Create a new var stmt.
  return newNimNode(nnkVarSection).add(
    newNimNode(nnkIdentDefs).add(name, newNimNode(nnkEmpty), value))

proc newLetStmt*(name, value: NimNode): NimNode =
  ## Create a new let stmt.
  return newNimNode(nnkLetSection).add(
    newNimNode(nnkIdentDefs).add(name, newNimNode(nnkEmpty), value))

proc newConstStmt*(name, value: NimNode): NimNode =
  ## Create a new const stmt.
  newNimNode(nnkConstSection).add(
    newNimNode(nnkConstDef).add(name, newNimNode(nnkEmpty), value))

proc newAssignment*(lhs, rhs: NimNode): NimNode =
  return newNimNode(nnkAsgn).add(lhs, rhs)

proc newDotExpr*(a, b: NimNode): NimNode =
  ## Create new dot expression.
  ## a.dot(b) -> `a.b`
  return newNimNode(nnkDotExpr).add(a, b)

proc newColonExpr*(a, b: NimNode): NimNode =
  ## Create new colon expression.
  ## newColonExpr(a, b) -> `a: b`
  newNimNode(nnkExprColonExpr).add(a, b)

proc newIdentDefs*(name, kind: NimNode;
                   default = newEmptyNode()): NimNode =
  ## Creates a new `nnkIdentDefs` node of a specific kind and value.
  ##
  ## `nnkIdentDefs` need to have at least three children, but they can have
  ## more: first comes a list of identifiers followed by a type and value
  ## nodes. This helper proc creates a three node subtree, the first subnode
  ## being a single identifier name. Both the `kind` node and `default`
  ## (value) nodes may be empty depending on where the `nnkIdentDefs`
  ## appears: tuple or object definitions will have an empty `default` node,
  ## `let` or `var` blocks may have an empty `kind` node if the
  ## identifier is being assigned a value. Example:
  ##
  ## .. code-block:: nim
  ##
  ##   var varSection = newNimNode(nnkVarSection).add(
  ##     newIdentDefs(ident("a"), ident("string")),
  ##     newIdentDefs(ident("b"), newEmptyNode(), newLit(3)))
  ##   # --> var
  ##   #       a: string
  ##   #       b = 3
  ##
  ## If you need to create multiple identifiers you need to use the lower level
  ## `newNimNode`:
  ##
  ## .. code-block:: nim
  ##
  ##   result = newNimNode(nnkIdentDefs).add(
  ##     ident("a"), ident("b"), ident("c"), ident("string"),
  ##       newStrLitNode("Hello"))
  newNimNode(nnkIdentDefs).add(name, kind, default)

proc newNilLit*(): NimNode =
  ## New nil literal shortcut.
  result = newNimNode(nnkNilLit)

proc last*(node: NimNode): NimNode = node[node.len-1]
  ## Return the last item in nodes children. Same as `node[^1]`.


const
  RoutineNodes* = {nnkProcDef, nnkFuncDef, nnkMethodDef, nnkDo, nnkLambda,
                   nnkIteratorDef, nnkTemplateDef, nnkConverterDef, nnkMacroDef}
  AtomicNodes* = {nnkNone..nnkNilLit}
  CallNodes* = {nnkCall, nnkInfix, nnkPrefix, nnkPostfix, nnkCommand,
    nnkCallStrLit, nnkHiddenCallConv}

proc expectKind*(n: NimNode; k: set[NimNodeKind]) =
  ## Checks that `n` is of kind `k`. If this is not the case,
  ## compilation aborts with an error message. This is useful for writing
  ## macros that check the AST that is passed to them.
  if n.kind notin k: error("Expected one of " & $k & ", got " & $n.kind, n)

proc newProc*(name = newEmptyNode();
              params: openArray[NimNode] = [newEmptyNode()];
              body: NimNode = newStmtList();
              procType = nnkProcDef;
              pragmas: NimNode = newEmptyNode()): NimNode =
  ## Shortcut for creating a new proc.
  ##
  ## The `params` array must start with the return type of the proc,
  ## followed by a list of IdentDefs which specify the params.
  if procType notin RoutineNodes:
    error("Expected one of " & $RoutineNodes & ", got " & $procType)
  pragmas.expectKind({nnkEmpty, nnkPragma})
  result = newNimNode(procType).add(
    name,
    newEmptyNode(),
    newEmptyNode(),
    newNimNode(nnkFormalParams).add(params),
    pragmas,
    newEmptyNode(),
    body)

proc newIfStmt*(branches: varargs[tuple[cond, body: NimNode]]): NimNode =
  ## Constructor for `if` statements.
  ##
  ## .. code-block:: nim
  ##
  ##    newIfStmt(
  ##      (Ident, StmtList),
  ##      ...
  ##    )
  ##
  result = newNimNode(nnkIfStmt)
  if len(branches) < 1:
    error("If statement must have at least one branch")
  for i in branches:
    result.add(newTree(nnkElifBranch, i.cond, i.body))

proc newEnum*(name: NimNode, fields: openArray[NimNode],
              public, pure: bool): NimNode =

  ## Creates a new enum. `name` must be an ident. Fields are allowed to be
  ## either idents or EnumFieldDef
  ##
  ## .. code-block:: nim
  ##
  ##    newEnum(
  ##      name    = ident("Colors"),
  ##      fields  = [ident("Blue"), ident("Red")],
  ##      public  = true, pure = false)
  ##
  ##    # type Colors* = Blue Red
  ##

  expectKind name, nnkIdent
  if len(fields) < 1:
    error("Enum must contain at least one field")
  for field in fields:
    expectKind field, {nnkIdent, nnkEnumFieldDef}

  let enumBody = newNimNode(nnkEnumTy).add(newEmptyNode()).add(fields)
  var typeDefArgs = [name, newEmptyNode(), enumBody]

  if public:
    let postNode = newNimNode(nnkPostfix).add(
      newIdentNode("*"), typeDefArgs[0])

    typeDefArgs[0] = postNode

  if pure:
    let pragmaNode = newNimNode(nnkPragmaExpr).add(
      typeDefArgs[0],
      add(newNimNode(nnkPragma), newIdentNode("pure")))

    typeDefArgs[0] = pragmaNode

  let
    typeDef   = add(newNimNode(nnkTypeDef), typeDefArgs)
    typeSect  = add(newNimNode(nnkTypeSection), typeDef)

  return typeSect

proc copyChildrenTo*(src, dest: NimNode) =
  ## Copy all children from `src` to `dest`.
  for i in 0 ..< src.len:
    dest.add src[i].copyNimTree

template expectRoutine(node: NimNode) =
  expectKind(node, RoutineNodes)

proc name*(someProc: NimNode): NimNode =
  someProc.expectRoutine
  result = someProc[0]
  if result.kind == nnkPostfix:
    if result[1].kind == nnkAccQuoted:
      result = result[1][0]
    else:
      result = result[1]
  elif result.kind == nnkAccQuoted:
    result = result[0]

proc `name=`*(someProc: NimNode; val: NimNode) =
  someProc.expectRoutine
  if someProc[0].kind == nnkPostfix:
    someProc[0][1] = val
  else: someProc[0] = val

proc params*(someProc: NimNode): NimNode =
  someProc.expectRoutine
  result = someProc[3]
proc `params=`* (someProc: NimNode; params: NimNode) =
  someProc.expectRoutine
  expectKind(params, nnkFormalParams)
  someProc[3] = params

proc pragma*(someProc: NimNode): NimNode =
  ## Get the pragma of a proc type.
  ## These will be expanded.
  if someProc.kind == nnkProcTy:
    result = someProc[1]
  else:
    someProc.expectRoutine
    result = someProc[4]
proc `pragma=`*(someProc: NimNode; val: NimNode) =
  ## Set the pragma of a proc type.
  expectKind(val, {nnkEmpty, nnkPragma})
  if someProc.kind == nnkProcTy:
    someProc[1] = val
  else:
    someProc.expectRoutine
    someProc[4] = val

proc addPragma*(someProc, pragma: NimNode) =
  ## Adds pragma to routine definition.
  someProc.expectKind(RoutineNodes + {nnkProcTy})
  var pragmaNode = someProc.pragma
  if pragmaNode.isNil or pragmaNode.kind == nnkEmpty:
    pragmaNode = newNimNode(nnkPragma)
    someProc.pragma = pragmaNode
  pragmaNode.add(pragma)

template badNodeKind(n, f) =
  error("Invalid node kind " & $n.kind & " for macros.`" & $f & "`", n)

proc body*(someProc: NimNode): NimNode =
  case someProc.kind:
  of RoutineNodes:
    return someProc[6]
  of nnkBlockStmt, nnkWhileStmt:
    return someProc[1]
  of nnkForStmt:
    return someProc.last
  else:
    badNodeKind someProc, "body"

proc `body=`*(someProc: NimNode, val: NimNode) =
  case someProc.kind
  of RoutineNodes:
    someProc[6] = val
  of nnkBlockStmt, nnkWhileStmt:
    someProc[1] = val
  of nnkForStmt:
    someProc[len(someProc)-1] = val
  else:
    badNodeKind someProc, "body="

proc basename*(a: NimNode): NimNode =
  ## Pull an identifier from prefix/postfix expressions.
  case a.kind
  of nnkIdent: result = a
  of nnkPostfix, nnkPrefix: result = a[1]
  of nnkPragmaExpr: result = basename(a[0])
  else:
    error("Do not know how to get basename of (" & treeRepr(a) & ")\n" &
      repr(a), a)

proc `$`*(node: NimNode): string =
  ## Get the string of an identifier node.
  case node.kind
  of nnkPostfix:
    result = node.basename.strVal & "*"
  of nnkStrLit..nnkTripleStrLit, nnkCommentStmt, nnkSym, nnkIdent:
    result = node.strVal
  of nnkOpenSymChoice, nnkClosedSymChoice:
    result = $node[0]
  of nnkAccQuoted:
    result = $node[0]
  else:
    badNodeKind node, "$"

iterator items*(n: NimNode): NimNode {.inline.} =
  ## Iterates over the children of the NimNode `n`.
  for i in 0 ..< n.len:
    yield n[i]

iterator pairs*(n: NimNode): (int, NimNode) {.inline.} =
  ## Iterates over the children of the NimNode `n` and its indices.
  for i in 0 ..< n.len:
    yield (i, n[i])

iterator children*(n: NimNode): NimNode {.inline.} =
  ## Iterates over the children of the NimNode `n`.
  for i in 0 ..< n.len:
    yield n[i]

template findChild*(n: NimNode; cond: untyped): NimNode {.dirty.} =
  ## Find the first child node matching condition (or nil).
  ##
  ## .. code-block:: nim
  ##   var res = findChild(n, it.kind == nnkPostfix and
  ##                          it.basename.ident == toNimIdent"foo")
  block:
    var res: NimNode
    for it in n.children:
      if cond:
        res = it
        break
    res

proc insert*(a: NimNode; pos: int; b: NimNode) =
  ## Insert node `b` into node `a` at `pos`.
  if len(a)-1 < pos:
    # add some empty nodes first
    for i in len(a)-1..pos-2:
      a.add newEmptyNode()
    a.add b
  else:
    # push the last item onto the list again
    # and shift each item down to pos up one
    a.add(a[a.len-1])
    for i in countdown(len(a) - 3, pos):
      a[i + 1] = a[i]
    a[pos] = b

proc `basename=`*(a: NimNode; val: string) =
  case a.kind
  of nnkIdent:
    a.strVal = val
  of nnkPostfix, nnkPrefix:
    a[1] = ident(val)
  of nnkPragmaExpr: `basename=`(a[0], val)
  else:
    error("Do not know how to get basename of (" & treeRepr(a) & ")\n" &
      repr(a), a)

proc postfix*(node: NimNode; op: string): NimNode =
  newNimNode(nnkPostfix).add(ident(op), node)

proc prefix*(node: NimNode; op: string): NimNode =
  newNimNode(nnkPrefix).add(ident(op), node)

proc infix*(a: NimNode; op: string;
            b: NimNode): NimNode =
  newNimNode(nnkInfix).add(ident(op), a, b)

proc unpackPostfix*(node: NimNode): tuple[node: NimNode; op: string] =
  node.expectKind nnkPostfix
  result = (node[1], $node[0])

proc unpackPrefix*(node: NimNode): tuple[node: NimNode; op: string] =
  node.expectKind nnkPrefix
  result = (node[1], $node[0])

proc unpackInfix*(node: NimNode): tuple[left: NimNode; op: string; right: NimNode] =
  expectKind(node, nnkInfix)
  result = (node[1], $node[0], node[2])

proc copy*(node: NimNode): NimNode =
  ## An alias for `copyNimTree<#copyNimTree,NimNode>`_.
  return node.copyNimTree()

proc expectIdent*(n: NimNode, name: string) {.since: (1,1).} =
  ## Check that `eqIdent(n,name)` holds true. If this is not the
  ## case, compilation aborts with an error message. This is useful
  ## for writing macros that check the AST that is passed to them.
  if not eqIdent(n, name):
    error("Expected identifier to be `" & name & "` here", n)

proc hasArgOfName*(params: NimNode; name: string): bool =
  ## Search `nnkFormalParams` for an argument.
  expectKind(params, nnkFormalParams)
  for i in 1..<params.len:
    for j in 0..<params[i].len-2:
      if name.eqIdent($params[i][j]):
        return true

proc addIdentIfAbsent*(dest: NimNode, ident: string) =
  ## Add `ident` to `dest` if it is not present. This is intended for use
  ## with pragmas.
  for node in dest.children:
    case node.kind
    of nnkIdent:
      if ident.eqIdent($node): return
    of nnkExprColonExpr:
      if ident.eqIdent($node[0]): return
    else: discard
  dest.add(ident(ident))

proc boolVal*(n: NimNode): bool {.noSideEffect.} =
  if n.kind == nnkIntLit: n.intVal != 0
  else: n == bindSym"true" # hacky solution for now

when defined(nimMacrosGetNodeId):
  proc nodeID*(n: NimNode): int {.magic: "NodeId".}
    ## Returns the id of `n`, when the compiler has been compiled
    ## with the flag `-d:useNodeids`, otherwise returns `-1`. This
    ## proc is for the purpose to debug the compiler only.

macro expandMacros*(body: typed): untyped =
  ## Expands one level of macro - useful for debugging.
  ## Can be used to inspect what happens when a macro call is expanded,
  ## without altering its result.
  ##
  ## For instance,
  ##
  ## .. code-block:: nim
  ##   import std/[sugar, macros]
  ##
  ##   let
  ##     x = 10
  ##     y = 20
  ##   expandMacros:
  ##     dump(x + y)
  ##
  ## will actually dump `x + y`, but at the same time will print at
  ## compile time the expansion of the `dump` macro, which in this
  ## case is `debugEcho ["x + y", " = ", x + y]`.
  echo body.toStrLit
  result = body

proc findPragmaNodeInRecList(arg, fieldSym: NimNode): NimNode =
  case arg.kind
  of nnkRecList, nnkRecCase:
    for it in arg.children:
      result = findPragmaNodeInRecList(it, fieldSym)
      if result != nil: return
  of nnkOfBranch:
    return findPragmaNodeInRecList(arg[1], fieldSym)
  of nnkElse:
    return findPragmaNodeInRecList(arg[0], fieldSym)
  of nnkIdentDefs:
    for i in 0..<arg.len-2:
      result = findPragmaNodeInRecList(arg[i], fieldSym)
      if result != nil: return
  of nnkAccQuoted, nnkIdent, nnkSym, nnkPostfix:
    return nil
  of nnkPragmaExpr:
    var ident = arg[0]
    if ident.kind == nnkPostfix: ident = ident[1]
    if ident.kind == nnkAccQuoted: ident = ident[0]
    if eqIdent(ident, fieldSym):
      return arg[1]
  else:
    error("illegal arg: ", arg)

proc getPragmaNodeFromProcSym(sym: NimNode): NimNode =
  sym.expectKind nnkSym
  if sym.symKind != nskProc: error("expected proc sym", sym)

  let impl = sym.getImpl
  expectKind(impl, nnkProcDef)
  result = impl[4]

proc getPragmaNodeFromObjFieldSym(sym: NimNode): NimNode =
  sym.expectKind nnkSym
  if sym.symKind != nskField: error("expected field sym", sym)

  # note this is not ``getTypeImpl``, because the result of
  # ``getTypeImpl`` is cleaned up of any pragma expressions.
  let impl = sym.owner.getImpl
  impl.expectKind nnkTypeDef

  let objectTy = if impl[2].kind == nnkRefTy: impl[2][0]
                 else: impl[2]

  # only works on object types
  objectTy.expectKind nnkObjectTy

  let recList = objectTy[2]
  recList.expectKind nnkRecList
  result = findPragmaNodeInRecList(recList, sym)

proc getPragmaNodeFromTypeSym(sym: NimNode): NimNode =
  sym.expectKind nnkSym
  if sym.symKind != nskType: error("expected type sym", sym)
  let impl = sym.getImpl
  if impl.len > 0:
    impl.expectKind nnkTypeDef
    let pragmaExpr = impl[0]
    if pragmaExpr.kind == nnkPragmaExpr:
      result = pragmaExpr[1]

proc getPragmaNodeFromType(typ: NimNode): NimNode =
  case typ.kind
  of nnkSym:
    result = getPragmaNodeFromTypeSym(typ)
  of nnkProcTy:
    result = typ[1]
  else: error("illegal typ kind for argument: " & $typ.kind, typ)

proc getPragmaNodeFromVarLetSym(sym: NimNode): NimNode =
  sym.expectKind nnkSym
  if sym.symKind notin {nskVar, nskLet}: error("expected var/let sym", sym)
  let impl = sym.getImpl
  impl.expectKind nnkIdentDefs
  impl.expectLen 3
  let pragmaExpr = impl[0]
  if pragmaExpr.kind == nnkPragmaExpr:
    result = pragmaExpr[1]

proc getPragmasByName(pragmaExpr: NimNode, name: string): seq[NimNode] =
  if pragmaExpr.kind == nnkPragma:
    for it in pragmaExpr:
      if it.kind in nnkPragmaCallKinds:
        if eqIdent(it[0], name):
          result.add it
      elif it.kind == nnkSym:
        if eqIdent(it, name):
          result.add it

proc getCustomPragmaNodes(sym: NimNode, name: string): seq[NimNode] =
  sym.expectKind nnkSym
  case sym.symKind
  of nskField:
    result = getPragmaNodeFromObjFieldSym(sym).getPragmasByName(name)
  of nskProc:
    result = getPragmaNodeFromProcSym(sym).getPragmasByName(name)
  of nskType:
    result = getPragmaNodeFromTypeSym(sym).getPragmasByName(name)
  of nskParam:
    # When a typedesc parameter is passed to the macro, it will be of nskParam.
    let typeInst = getTypeInst(sym)
    if typeInst.kind == nnkBracketExpr and eqIdent(typeInst[0], "typeDesc"):
      result = getPragmaNodeFromTypeSym(typeInst[1]).getPragmasByName(name)
    else:
      error("illegal sym kind for argument: " & $sym.symKind, sym)
  of nskVar, nskLet:
    # This checks the type of the sym too, this is consistent with how
    # field expressions are handled too. If this is changed, make sure to
    # change it for fields expressions too.
    result = getPragmaNodeFromType(sym.getTypeInst).getPragmasByName(name)
    result.add getPragmaNodeFromVarLetSym(sym).getPragmasByName(name)
  else:
    error("illegal sym kind for argument: " & $sym.symKind, sym)

since (1, 5):
  export getCustomPragmaNodes

proc hasCustomPragma*(n: NimNode, name: string): bool =
  n.expectKind nnkSym
  result = getCustomPragmaNodes(n, name).len > 0

proc getCustomPragmaNodesSmart(n: NimNode, name: string): seq[NimNode] =
  case n.kind
  of nnkDotExpr:
    result = getCustomPragmaNodes(n[1], name)
  of nnkCheckedFieldExpr:
    expectKind n[0], nnkDotExpr
    result = getCustomPragmaNodes(n[0][1], name)
  of nnkSym:
    result = getCustomPragmaNodes(n, name)
  of nnkTypeOfExpr:
    var typ = n.getTypeInst
    while typ.kind == nnkBracketExpr and typ[0].eqIdent "typeDesc":
      typ = typ[1]
    result = getPragmaNodeFromType(typ).getPragmasByName(name)
  of nnkBracketExpr:
    discard
  else:
    n.expectKind({nnkDotExpr, nnkCheckedFieldExpr, nnkSym, nnkTypeOfExpr})

macro hasCustomPragma*(n: typed, cp: typed{nkSym}): bool =
  ## Expands to `true` if expression `n` which is expected to be `nnkDotExpr`
  ## (if checking a field), a proc or a type has custom pragma `cp`.
  ##
  ## See also `getCustomPragmaVal`.
  ##
  ## .. code-block:: nim
  ##   template myAttr() {.pragma.}
  ##   type
  ##     MyObj = object
  ##       myField {.myAttr.}: int
  ##
  ##   proc myProc() {.myAttr.} = discard
  ##
  ##   var o: MyObj
  ##   assert(o.myField.hasCustomPragma(myAttr))
  ##   assert(myProc.hasCustomPragma(myAttr))
  result = newLit(getCustomPragmaNodesSmart(n, $cp).len > 0)

iterator iterOverFormalArgs(f: NimNode): tuple[name, typ, val: NimNode] =
  f.expectKind nnkFormalParams
  for i in 1..<f.len:
    f[i].expectKind nnkIdentDefs
    let typ = f[i][^2]
    let val = f[i][^1]
    for j in 0..<f[i].len-2:
      yield (f[i][j], typ, val)

macro getCustomPragmaVal*(n: typed, cp: typed): untyped =
  ## Expands to value of custom pragma `cp` of expression `n` which is expected
  ## to be `nnkDotExpr`, a proc or a type.
  ##
  ## See also `hasCustomPragma`
  ##
  ## .. code-block:: nim
  ##   template serializationKey(key: string) {.pragma.}
  ##   type
  ##     MyObj {.serializationKey: "mo".} = object
  ##       myField {.serializationKey: "mf".}: int
  ##   var o: MyObj
  ##   assert(o.myField.getCustomPragmaVal(serializationKey) == "mf")
  ##   assert(o.getCustomPragmaVal(serializationKey) == "mo")
  ##   assert(MyObj.getCustomPragmaVal(serializationKey) == "mo")
  n.expectKind {nnkDotExpr, nnkCheckedFieldExpr, nnkSym, nnkTypeOfExpr}
  cp.expectKind {nnkSym, nnkOpenSymChoice, nnkClosedSymChoice}
  let pragmaNodes = getCustomPragmaNodesSmart(n, $cp)
  if pragmaNodes.len == 0:
    error(n.repr & " doesn't have any custom pragmas")
  let pragmaNode = pragmaNodes[^1]

  case pragmaNode.kind
  of nnkPragmaCallKinds:
    if pragmaNode.len == 2:
      result = pragmaNode[1]
    else:
      # create a named tuple expression for pragmas with multiple arguments
      result = newTree(nnkPar)
      var i = 1
      for (key, t, v) in iterOverFormalArgs(pragmaNode[0].getImpl[3]):
        result.add nnkExprColonExpr.newTree(key, pragmaNode[i])
        inc i
  of nnkSym:
    error("The named pragma " & cp.repr & " in " & n.repr & " has no arguments and therefore no value.")
  else:
    error(n.repr & " doesn't have a pragma named " & cp.repr, n)

macro unpackVarargs*(callee: untyped; args: varargs[untyped]): untyped =
  ## Calls `callee` with `args` unpacked as individual arguments.
  ## This is useful in 2 cases:
  ## * when forwarding `varargs[T]` for some typed `T`
  ## * when forwarding `varargs[untyped]` when `args` can potentially be empty,
  ##   due to a compiler limitation
  runnableExamples:
    template call1(fun: typed; args: varargs[untyped]): untyped =
      unpackVarargs(fun, args)
      # when varargsLen(args) > 0: fun(args) else: fun() # this would also work
    template call2(fun: typed; args: varargs[typed]): untyped =
      unpackVarargs(fun, args)
    proc fn1(a = 0, b = 1) = discard (a, b)
    call1(fn1, 10, 11)
    call1(fn1) # `args` is empty in this case
    if false: call2(echo, 10, 11) # would print 1011
  result = newCall(callee)
  for i in 0 ..< args.len:
    result.add args[i]

proc getProjectPath*(): string = discard
  ## Returns the path to the currently compiling project.
  ##
  ## This is not to be confused with `system.currentSourcePath <system.html#currentSourcePath.t>`_
  ## which returns the path of the source file containing that template
  ## call.
  ##
  ## For example, assume a `dir1/foo.nim` that imports a `dir2/bar.nim`,
  ## have the `bar.nim` print out both `getProjectPath` and
  ## `currentSourcePath` outputs.
  ##
  ## Now when `foo.nim` is compiled, the `getProjectPath` from
  ## `bar.nim` will return the `dir1/` path, while the `currentSourcePath`
  ## will return the path to the `bar.nim` source file.
  ##
  ## Now when `bar.nim` is compiled directly, the `getProjectPath`
  ## will now return the `dir2/` path, and the `currentSourcePath`
  ## will still return the same path, the path to the `bar.nim` source
  ## file.
  ##
  ## The path returned by this proc is set at compile time.
  ##
  ## See also:
  ## * `getCurrentDir proc <os.html#getCurrentDir>`_

proc getSize*(arg: NimNode): int {.magic: "NSizeOf", noSideEffect.} =
  ## Returns the same result as `system.sizeof` if the size is
  ## known by the Nim compiler. Returns a negative value if the Nim
  ## compiler does not know the size.
proc getAlign*(arg: NimNode): int {.magic: "NSizeOf", noSideEffect.} =
  ## Returns the same result as `system.alignof` if the alignment
  ## is known by the Nim compiler. It works on `NimNode` for use
  ## in macro context. Returns a negative value if the Nim compiler
  ## does not know the alignment.
proc getOffset*(arg: NimNode): int {.magic: "NSizeOf", noSideEffect.} =
  ## Returns the same result as `system.offsetof` if the offset is
  ## known by the Nim compiler. It expects a resolved symbol node
  ## from a field of a type. Therefore it only requires one argument
  ## instead of two. Returns a negative value if the Nim compiler
  ## does not know the offset.

proc isExported*(n: NimNode): bool {.noSideEffect.} =
  ## Returns whether the symbol is exported or not.

proc extractDocCommentsAndRunnables*(n: NimNode): NimNode =
  ## returns a `nnkStmtList` containing the top-level doc comments and
  ## runnableExamples in `a`, stopping at the first child that is neither.
  ## Example:
  ##
  ## .. code-block:: nim
  ##  import std/macros
  ##  macro transf(a): untyped =
  ##    result = quote do:
  ##      proc fun2*() = discard
  ##    let header = extractDocCommentsAndRunnables(a.body)
  ##    # correct usage: rest is appended
  ##    result.body = header
  ##    result.body.add quote do: discard # just an example
  ##    # incorrect usage: nesting inside a nnkStmtList:
  ##    # result.body = quote do: (`header`; discard)
  ##
  ##  proc fun*() {.transf.} =
  ##    ## first comment
  ##    runnableExamples: discard
  ##    runnableExamples: discard
  ##    ## last comment
  ##    discard # first statement after doc comments + runnableExamples
  ##    ## not docgen'd

  result = newStmtList()
  for ni in n:
    case ni.kind
    of nnkCommentStmt:
      result.add ni
    of nnkCall:
      if ni[0].kind == nnkIdent and ni[0].strVal == "runnableExamples":
        result.add ni
      else: break
    else: break
