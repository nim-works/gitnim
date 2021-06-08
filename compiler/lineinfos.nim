#
#
#           The Nim Compiler
#        (c) Copyright 2018 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

## This module contains the ``TMsgKind`` enum as well as the
## ``TLineInfo`` object.

import ropes, tables, pathutils

const
  explanationsBaseUrl* = "https://nim-lang.org/docs"

type
  TMsgKind* = enum
    errUnknown, errInternal, errIllFormedAstX, errCannotOpenFile,
    errXExpected,
    errGridTableNotImplemented,
    errGeneralParseError,
    errNewSectionExpected,
    errInvalidDirectiveX,
    errProveInit,
    errGenerated,
    errUser,
    warnCannotOpenFile,
    warnOctalEscape, warnXIsNeverRead, warnXmightNotBeenInit,
    warnDeprecated, warnConfigDeprecated,
    warnSmallLshouldNotBeUsed, warnUnknownMagic, warnRedefinitionOfLabel,
    warnUnknownSubstitutionX, warnLanguageXNotSupported,
    warnFieldXNotSupported, warnCommentXIgnored,
    warnTypelessParam,
    warnUseBase, warnWriteToForeignHeap, warnUnsafeCode,
    warnUnusedImportX,
    warnInheritFromException,
    warnEachIdentIsTuple,
    warnUnsafeSetLen,
    warnUnsafeDefault,
    warnProveInit, warnProveField, warnProveIndex,
    warnStaticIndexCheck, warnGcUnsafe, warnGcUnsafe2,
    warnUninit, warnGcMem, warnDestructor, warnLockLevel, warnResultShadowed,
    warnInconsistentSpacing, warnCaseTransition, warnCycleCreated,
    warnObservableStores,
    warnResultUsed,
    warnUser,
    hintSuccess, hintSuccessX, hintCC,
    hintLineTooLong, hintXDeclaredButNotUsed,
    hintConvToBaseNotNeeded,
    hintConvFromXtoItselfNotNeeded, hintExprAlwaysX, hintQuitCalled,
    hintProcessing, hintCodeBegin, hintCodeEnd, hintConf, hintPath,
    hintConditionAlwaysTrue, hintConditionAlwaysFalse, hintName, hintPattern,
    hintExecuting, hintLinking, hintDependency,
    hintSource, hintPerformance, hintStackTrace, hintGCStats,
    hintGlobalVar, hintExpandMacro,
    hintUser, hintUserRaw,
    hintExtendedContext

const
  MsgKindToStr*: array[TMsgKind, string] = [
    errUnknown: "unknown error",
    errInternal: "internal error: $1",
    errIllFormedAstX: "illformed AST: $1",
    errCannotOpenFile: "cannot open '$1'",
    errXExpected: "'$1' expected",
    errGridTableNotImplemented: "grid table is not implemented",
    errGeneralParseError: "general parse error",
    errNewSectionExpected: "new section expected",
    errInvalidDirectiveX: "invalid directive: '$1'",
    errProveInit: "Cannot prove that '$1' is initialized.",
    errGenerated: "$1",
    errUser: "$1",
    warnCannotOpenFile: "cannot open '$1'",
    warnOctalEscape: "octal escape sequences do not exist; leading zero is ignored",
    warnXIsNeverRead: "'$1' is never read",
    warnXmightNotBeenInit: "'$1' might not have been initialized",
    warnDeprecated: "$1",
    warnConfigDeprecated: "config file '$1' is deprecated",
    warnSmallLshouldNotBeUsed: "'l' should not be used as an identifier; may look like '1' (one)",
    warnUnknownMagic: "unknown magic '$1' might crash the compiler",
    warnRedefinitionOfLabel: "redefinition of label '$1'",
    warnUnknownSubstitutionX: "unknown substitution '$1'",
    warnLanguageXNotSupported: "language '$1' not supported",
    warnFieldXNotSupported: "field '$1' not supported",
    warnCommentXIgnored: "comment '$1' ignored",
    warnTypelessParam: "'$1' has no type. Typeless parameters are deprecated; only allowed for 'template'",
    warnUseBase: "use {.base.} for base methods; baseless methods are deprecated",
    warnWriteToForeignHeap: "write to foreign heap",
    warnUnsafeCode: "unsafe code: '$1'",
    warnUnusedImportX: "imported and not used: '$1'",
    warnInheritFromException: "inherit from a more precise exception type like ValueError, " &
      "IOError or OSError. If these don't suit, inherit from CatchableError or Defect.",
    warnEachIdentIsTuple: "each identifier is a tuple",
    warnUnsafeSetLen: "setLen can potentially expand the sequence, " &
                      "but the element type '$1' doesn't have a valid default value",
    warnUnsafeDefault: "The '$1' type doesn't have a valid default value",
    warnProveInit: "Cannot prove that '$1' is initialized. This will become a compile time error in the future.",
    warnProveField: "cannot prove that field '$1' is accessible",
    warnProveIndex: "cannot prove index '$1' is valid",
    warnStaticIndexCheck: "$1",
    warnGcUnsafe: "not GC-safe: '$1'",
    warnGcUnsafe2: "$1",
    warnUninit: "'$1' might not have been initialized",
    warnGcMem: "'$1' uses GC'ed memory",
    warnDestructor: "usage of a type with a destructor in a non destructible context. This will become a compile time error in the future.",
    warnLockLevel: "$1",
    warnResultShadowed: "Special variable 'result' is shadowed.",
    warnInconsistentSpacing: "Number of spaces around '$#' is not consistent",
    warnCaseTransition: "Potential object case transition, instantiate new object instead",
    warnCycleCreated: "$1",
    warnObservableStores: "observable stores to '$1'",
    warnResultUsed: "used 'result' variable",
    warnUser: "$1",
    hintSuccess: "operation successful: $#",
    # keep in sync with `testament.isSuccess`
    hintSuccessX: "$loc LOC; $sec sec; $mem; $build build; proj: $project; out: $output",
    hintCC: "CC: $1",
    hintLineTooLong: "line too long",
    hintXDeclaredButNotUsed: "'$1' is declared but not used",
    hintConvToBaseNotNeeded: "conversion to base object is not needed",
    hintConvFromXtoItselfNotNeeded: "conversion from $1 to itself is pointless",
    hintExprAlwaysX: "expression evaluates always to '$1'",
    hintQuitCalled: "quit() called",
    hintProcessing: "$1",
    hintCodeBegin: "generated code listing:",
    hintCodeEnd: "end of listing",
    hintConf: "used config file '$1'",
    hintPath: "added path: '$1'",
    hintConditionAlwaysTrue: "condition is always true: '$1'",
    hintConditionAlwaysFalse: "condition is always false: '$1'",
    hintName: "$1",
    hintPattern: "$1",
    hintExecuting: "$1",
    hintLinking: "$1",
    hintDependency: "$1",
    hintSource: "$1",
    hintPerformance: "$1",
    hintStackTrace: "$1",
    hintGCStats: "$1",
    hintGlobalVar: "global variable declared here",
    hintExpandMacro: "expanded macro: $1",
    hintUser: "$1",
    hintUserRaw: "$1",
    hintExtendedContext: "$1",
  ]

const
  WarningsToStr* = ["CannotOpenFile", "OctalEscape",
    "XIsNeverRead", "XmightNotBeenInit",
    "Deprecated", "ConfigDeprecated",
    "SmallLshouldNotBeUsed", "UnknownMagic",
    "RedefinitionOfLabel", "UnknownSubstitutionX",
    "LanguageXNotSupported", "FieldXNotSupported",
    "CommentXIgnored",
    "TypelessParam", "UseBase", "WriteToForeignHeap",
    "UnsafeCode", "UnusedImport", "InheritFromException",
    "EachIdentIsTuple",
    "UnsafeSetLen", "UnsafeDefault",
    "ProveInit", "ProveField", "ProveIndex",
    "IndexCheck", "GcUnsafe", "GcUnsafe2", "Uninit",
    "GcMem", "Destructor", "LockLevel", "ResultShadowed",
    "Spacing", "CaseTransition", "CycleCreated",
    "ObservableStores", "ResultUsed", "User"]

  HintsToStr* = [
    "Success", "SuccessX", "CC", "LineTooLong",
    "XDeclaredButNotUsed",
    "ConvToBaseNotNeeded", "ConvFromXtoItselfNotNeeded",
    "ExprAlwaysX", "QuitCalled", "Processing", "CodeBegin", "CodeEnd", "Conf",
    "Path", "CondTrue", "CondFalse", "Name", "Pattern", "Exec", "Link", "Dependency",
    "Source", "Performance", "StackTrace", "GCStats", "GlobalVar", "ExpandMacro",
    "User", "UserRaw", "ExtendedContext",
  ]

const
  fatalMin* = errUnknown
  fatalMax* = errInternal
  errMin* = errUnknown
  errMax* = errUser
  warnMin* = warnCannotOpenFile
  warnMax* = pred(hintSuccess)
  hintMin* = hintSuccess
  hintMax* = high(TMsgKind)

static:
  doAssert HintsToStr.len == ord(hintMax) - ord(hintMin) + 1
  doAssert WarningsToStr.len == ord(warnMax) - ord(warnMin) + 1

type
  TNoteKind* = range[warnMin..hintMax] # "notes" are warnings or hints
  TNoteKinds* = set[TNoteKind]

proc computeNotesVerbosity(): array[0..3, TNoteKinds] =
  result[3] = {low(TNoteKind)..high(TNoteKind)} - {warnResultUsed}
  result[2] = result[3] - {hintStackTrace, warnUninit, hintExtendedContext}
  result[1] = result[2] - {warnProveField, warnProveIndex,
    warnGcUnsafe, hintPath, hintDependency, hintCodeBegin, hintCodeEnd,
    hintSource, hintGlobalVar, hintGCStats}
  result[0] = result[1] - {hintSuccessX, hintSuccess, hintConf,
    hintProcessing, hintPattern, hintExecuting, hintLinking, hintCC}

const
  NotesVerbosity* = computeNotesVerbosity()
  errXMustBeCompileTime* = "'$1' can only be used in compile-time context"
  errArgsNeedRunOption* = "arguments can only be given if the '--run' option is selected"

type
  TFileInfo* = object
    fullPath*: AbsoluteFile    # This is a canonical full filesystem path
    projPath*: RelativeFile    # This is relative to the project's root
    shortName*: string         # short name of the module
    quotedName*: Rope          # cached quoted short name for codegen
                               # purposes
    quotedFullName*: Rope      # cached quoted full name for codegen
                               # purposes

    lines*: seq[string]        # the source code of the module
                               #   used for better error messages and
                               #   embedding the original source in the
                               #   generated code
    dirtyFile*: AbsoluteFile   # the file that is actually read into memory
                               # and parsed; usually "" but is used
                               # for 'nimsuggest'
    hash*: string              # the checksum of the file
    dirty*: bool               # for 'nimfix' / 'nimpretty' like tooling
    when defined(nimpretty):
      fullContent*: string
  FileIndex* = distinct int32
  TLineInfo* = object          # This is designed to be as small as possible,
                               # because it is used
                               # in syntax nodes. We save space here by using
                               # two int16 and an int32.
                               # On 64 bit and on 32 bit systems this is
                               # only 8 bytes.
    line*: uint16
    col*: int16
    fileIndex*: FileIndex
    when defined(nimpretty):
      offsetA*, offsetB*: int
      commentOffsetA*, commentOffsetB*: int

  TErrorOutput* = enum
    eStdOut
    eStdErr

  TErrorOutputs* = set[TErrorOutput]

  ERecoverableError* = object of ValueError
  ESuggestDone* = object of ValueError

proc `==`*(a, b: FileIndex): bool {.borrow.}

proc raiseRecoverableError*(msg: string) {.noinline.} =
  raise newException(ERecoverableError, msg)

const
  InvalidFileIdx* = FileIndex(-1)
  unknownLineInfo* = TLineInfo(line: 0, col: -1, fileIndex: InvalidFileIdx)

type
  Severity* {.pure.} = enum ## VS Code only supports these three
    Hint, Warning, Error

const
  trackPosInvalidFileIdx* = FileIndex(-2) # special marker so that no suggestions
                                          # are produced within comments and string literals
  commandLineIdx* = FileIndex(-3)

type
  MsgConfig* = object ## does not need to be stored in the incremental cache
    trackPos*: TLineInfo
    trackPosAttached*: bool ## whether the tracking position was attached to
                            ## some close token.

    errorOutputs*: TErrorOutputs
    msgContext*: seq[tuple[info: TLineInfo, detail: string]]
    lastError*: TLineInfo
    filenameToIndexTbl*: Table[string, FileIndex]
    fileInfos*: seq[TFileInfo]
    systemFileIdx*: FileIndex


proc initMsgConfig*(): MsgConfig =
  result.msgContext = @[]
  result.lastError = unknownLineInfo
  result.filenameToIndexTbl = initTable[string, FileIndex]()
  result.fileInfos = @[]
  result.errorOutputs = {eStdOut, eStdErr}
