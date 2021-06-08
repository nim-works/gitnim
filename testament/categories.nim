#
#
#            Nim Tester
#        (c) Copyright 2015 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

## Include for the tester that contains test suites that test special features
## of the compiler.

# included from testament.nim

import important_packages

const
  specialCategories = [
    "assert",
    "async",
    "debugger",
    "dll",
    "examples",
    "flags",
    "gc",
    "io",
    "js",
    "ic",
    "lib",
    "longgc",
    "manyloc",
    "nimble-packages-1",
    "nimble-packages-2",
    "niminaction",
    "threads",
    "untestable",
    "testdata",
    "nimcache",
    "coroutines",
    "osproc",
    "shouldfail",
    "dir with space",
    "destructor"
  ]

proc isTestFile*(file: string): bool =
  let (_, name, ext) = splitFile(file)
  result = ext == ".nim" and name.startsWith("t")

# ---------------- IC tests ---------------------------------------------

proc icTests(r: var TResults; testsDir: string, cat: Category, options: string) =
  const
    tooltests = ["compiler/nim.nim", "tools/nimgrep.nim"]
    writeOnly = " --incremental:writeonly "
    readOnly = " --incremental:readonly "
    incrementalOn = " --incremental:on "

  template test(x: untyped) =
    testSpecWithNimcache(r, makeRawTest(file, x & options, cat), nimcache)

  template editedTest(x: untyped) =
    var test = makeTest(file, x & options, cat)
    test.spec.targets = {getTestSpecTarget()}
    testSpecWithNimcache(r, test, nimcache)

  const tempExt = "_temp.nim"
  for it in walkDirRec(testsDir / "ic"):
    if isTestFile(it) and not it.endsWith(tempExt):
      let nimcache = nimcacheDir(it, options, getTestSpecTarget())
      removeDir(nimcache)

      let content = readFile(it)
      for fragment in content.split("#!EDIT!#"):
        let file = it.replace(".nim", tempExt)
        writeFile(file, fragment)
        let oldPassed = r.passed
        editedTest incrementalOn
        if r.passed != oldPassed+1: break

  for file in tooltests:
    let nimcache = nimcacheDir(file, options, getTestSpecTarget())
    removeDir(nimcache)

    let oldPassed = r.passed
    test writeOnly

    if r.passed == oldPassed+1:
      test readOnly
      if r.passed == oldPassed+2:
        test readOnly & "-d:nimBackendAssumesChange "

# --------------------- flags tests -------------------------------------------

proc flagTests(r: var TResults, cat: Category, options: string) =
  # --genscript
  const filename = testsDir/"flags"/"tgenscript"
  const genopts = " --genscript"
  let nimcache = nimcacheDir(filename, genopts, targetC)
  testSpec r, makeTest(filename, genopts, cat)

  when defined(windows):
    testExec r, makeTest(filename, " cmd /c cd " & nimcache &
                         " && compile_tgenscript.bat", cat)

  elif defined(posix):
    testExec r, makeTest(filename, " sh -c \"cd " & nimcache &
                         " && sh compile_tgenscript.sh\"", cat)

  # Run
  testExec r, makeTest(filename, " " & nimcache / "tgenscript", cat)

# --------------------- DLL generation tests ----------------------------------

proc runBasicDLLTest(c, r: var TResults, cat: Category, options: string) =
  const rpath = when defined(macosx):
      " --passL:-rpath --passL:@loader_path"
    else:
      ""

  var test1 = makeTest("lib/nimrtl.nim", options & " --outdir:tests/dll", cat)
  test1.spec.action = actionCompile
  testSpec c, test1
  var test2 = makeTest("tests/dll/server.nim", options & " --threads:on" & rpath, cat)
  test2.spec.action = actionCompile
  testSpec c, test2
  var test3 = makeTest("lib/nimhcr.nim", options & " --outdir:tests/dll" & rpath, cat)
  test3.spec.action = actionCompile
  testSpec c, test3
  var test4 = makeTest("tests/dll/visibility.nim", options & " --app:lib" & rpath, cat)
  test4.spec.action = actionCompile
  testSpec c, test4

  # windows looks in the dir of the exe (yay!):
  when not defined(Windows):
    # posix relies on crappy LD_LIBRARY_PATH (ugh!):
    const libpathenv = when defined(haiku): "LIBRARY_PATH"
                       else: "LD_LIBRARY_PATH"
    var libpath = getEnv(libpathenv).string
    # Temporarily add the lib directory to LD_LIBRARY_PATH:
    putEnv(libpathenv, "tests/dll" & (if libpath.len > 0: ":" & libpath else: ""))
    defer: putEnv(libpathenv, libpath)

  testSpec r, makeTest("tests/dll/client.nim", options & " --threads:on" & rpath, cat)
  testSpec r, makeTest("tests/dll/nimhcr_unit.nim", options & rpath, cat)
  testSpec r, makeTest("tests/dll/visibility.nim", options & rpath, cat)

  if "boehm" notin options:
    # force build required - see the comments in the .nim file for more details
    var hcri = makeTest("tests/dll/nimhcr_integration.nim",
                                   options & " --forceBuild --hotCodeReloading:on" & rpath, cat)
    let nimcache = nimcacheDir(hcri.name, hcri.options, getTestSpecTarget())
    hcri.args = prepareTestArgs(hcri.spec.getCmd, hcri.name,
                                hcri.options, nimcache, getTestSpecTarget())
    testSpec r, hcri

proc dllTests(r: var TResults, cat: Category, options: string) =
  # dummy compile result:
  var c = initResults()

  runBasicDLLTest c, r, cat, options
  runBasicDLLTest c, r, cat, options & " -d:release"
  when not defined(windows):
    # still cannot find a recent Windows version of boehm.dll:
    runBasicDLLTest c, r, cat, options & " --gc:boehm"
    runBasicDLLTest c, r, cat, options & " -d:release --gc:boehm"

# ------------------------------ GC tests -------------------------------------

proc gcTests(r: var TResults, cat: Category, options: string) =
  template testWithoutMs(filename: untyped) =
    testSpec r, makeTest("tests/gc" / filename, options, cat)
    testSpec r, makeTest("tests/gc" / filename, options &
                  " -d:release -d:useRealtimeGC", cat)
    when filename != "gctest":
      testSpec r, makeTest("tests/gc" / filename, options &
                    " --gc:orc", cat)
      testSpec r, makeTest("tests/gc" / filename, options &
                    " --gc:orc -d:release", cat)

  template testWithoutBoehm(filename: untyped) =
    testWithoutMs filename
    testSpec r, makeTest("tests/gc" / filename, options &
                  " --gc:markAndSweep", cat)
    testSpec r, makeTest("tests/gc" / filename, options &
                  " -d:release --gc:markAndSweep", cat)

  template test(filename: untyped) =
    testWithoutBoehm filename
    when not defined(windows) and not defined(android):
      # AR: cannot find any boehm.dll on the net, right now, so disabled
      # for windows:
      testSpec r, makeTest("tests/gc" / filename, options &
                    " --gc:boehm", cat)
      testSpec r, makeTest("tests/gc" / filename, options &
                    " -d:release --gc:boehm", cat)

  testWithoutBoehm "foreign_thr"
  test "gcemscripten"
  test "growobjcrash"
  test "gcbench"
  test "gcleak"
  test "gcleak2"
  testWithoutBoehm "gctest"
  test "gcleak3"
  test "gcleak4"
  # Disabled because it works and takes too long to run:
  #test "gcleak5"
  testWithoutBoehm "weakrefs"
  test "cycleleak"
  testWithoutBoehm "closureleak"
  testWithoutMs "refarrayleak"

  testWithoutBoehm "tlists"
  testWithoutBoehm "thavlak"

  test "stackrefleak"
  test "cyclecollector"
  testWithoutBoehm "trace_globals"

proc longGCTests(r: var TResults, cat: Category, options: string) =
  when defined(windows):
    let cOptions = "-ldl -DWIN"
  else:
    let cOptions = "-ldl"

  var c = initResults()
  # According to ioTests, this should compile the file
  testSpec c, makeTest("tests/realtimeGC/shared", options, cat)
  #        ^- why is this not appended to r? Should this be discarded?
  testC r, makeTest("tests/realtimeGC/cmain", cOptions, cat), actionRun
  testSpec r, makeTest("tests/realtimeGC/nmain", options & "--threads: on", cat)

# ------------------------- threading tests -----------------------------------

proc threadTests(r: var TResults, cat: Category, options: string) =
  template test(filename: untyped) =
    testSpec r, makeTest(filename, options, cat)
    testSpec r, makeTest(filename, options & " -d:release", cat)
    testSpec r, makeTest(filename, options & " --tlsEmulation:on", cat)
  for t in os.walkFiles("tests/threads/t*.nim"):
    test(t)

# ------------------------- IO tests ------------------------------------------

proc ioTests(r: var TResults, cat: Category, options: string) =
  # We need readall_echo to be compiled for this test to run.
  # dummy compile result:
  var c = initResults()
  testSpec c, makeTest("tests/system/helpers/readall_echo", options, cat)
  testSpec r, makeTest("tests/system/tio", options, cat)

# ------------------------- async tests ---------------------------------------
proc asyncTests(r: var TResults, cat: Category, options: string) =
  template test(filename: untyped) =
    testSpec r, makeTest(filename, options, cat)
  for t in os.walkFiles("tests/async/t*.nim"):
    test(t)

# ------------------------- debugger tests ------------------------------------

proc debuggerTests(r: var TResults, cat: Category, options: string) =
  if fileExists("tools/nimgrep.nim"):
    var t = makeTest("tools/nimgrep", options & " --debugger:on", cat)
    t.spec.action = actionCompile
    testSpec r, t

# ------------------------- JS tests ------------------------------------------

proc jsTests(r: var TResults, cat: Category, options: string) =
  template test(filename: untyped) =
    testSpec r, makeTest(filename, options, cat), {targetJS}
    testSpec r, makeTest(filename, options & " -d:release", cat), {targetJS}

  for t in os.walkFiles("tests/js/t*.nim"):
    test(t)
  for testfile in ["exception/texceptions", "exception/texcpt1",
                   "exception/texcsub", "exception/tfinally",
                   "exception/tfinally2", "exception/tfinally3",
                   "actiontable/tactiontable", "method/tmultimjs",
                   "varres/tvarres0", "varres/tvarres3", "varres/tvarres4",
                   "varres/tvartup", "misc/tints", "misc/tunsignedinc",
                   "async/tjsandnativeasync"]:
    test "tests/" & testfile & ".nim"

  for testfile in ["strutils", "json", "random", "times", "logging"]:
    test "lib/pure/" & testfile & ".nim"

# ------------------------- nim in action -----------

proc testNimInAction(r: var TResults, cat: Category, options: string) =
  let options = options & " --nilseqs:on"

  template test(filename: untyped) =
    testSpec r, makeTest(filename, options, cat)

  template testJS(filename: untyped) =
    testSpec r, makeTest(filename, options, cat), {targetJS}

  template testCPP(filename: untyped) =
    testSpec r, makeTest(filename, options, cat), {targetCpp}

  let tests = [
    "niminaction/Chapter1/various1",
    "niminaction/Chapter2/various2",
    "niminaction/Chapter2/resultaccept",
    "niminaction/Chapter2/resultreject",
    "niminaction/Chapter2/explicit_discard",
    "niminaction/Chapter2/no_def_eq",
    "niminaction/Chapter2/no_iterator",
    "niminaction/Chapter2/no_seq_type",
    "niminaction/Chapter3/ChatApp/src/server",
    "niminaction/Chapter3/ChatApp/src/client",
    "niminaction/Chapter3/various3",
    "niminaction/Chapter6/WikipediaStats/concurrency_regex",
    "niminaction/Chapter6/WikipediaStats/concurrency",
    "niminaction/Chapter6/WikipediaStats/naive",
    "niminaction/Chapter6/WikipediaStats/parallel_counts",
    "niminaction/Chapter6/WikipediaStats/race_condition",
    "niminaction/Chapter6/WikipediaStats/sequential_counts",
    "niminaction/Chapter6/WikipediaStats/unguarded_access",
    "niminaction/Chapter7/Tweeter/src/tweeter",
    "niminaction/Chapter7/Tweeter/src/createDatabase",
    "niminaction/Chapter7/Tweeter/tests/database_test",
    "niminaction/Chapter8/sdl/sdl_test"
    ]

  when false:
    # Verify that the files have not been modified. Death shall fall upon
    # whoever edits these hashes without dom96's permission, j/k. But please only
    # edit when making a conscious breaking change, also please try to make your
    # commit message clear and notify me so I can easily compile an errata later.
    # ---------------------------------------------------------
    # Hash-checks are disabled for Nim 1.1 and beyond
    # since we needed to fix the deprecated unary '<' operator.
    const refHashes = @[
      "51afdfa84b3ca3d810809d6c4e5037ba",
      "30f07e4cd5eaec981f67868d4e91cfcf",
      "d14e7c032de36d219c9548066a97e846",
      "b335635562ff26ec0301bdd86356ac0c",
      "6c4add749fbf50860e2f523f548e6b0e",
      "76de5833a7cc46f96b006ce51179aeb1",
      "705eff79844e219b47366bd431658961",
      "a1e87b881c5eb161553d119be8b52f64",
      "2d706a6ec68d2973ec7e733e6d5dce50",
      "c11a013db35e798f44077bc0763cc86d",
      "3e32e2c5e9a24bd13375e1cd0467079c",
      "a5452722b2841f0c1db030cf17708955",
      "dc6c45eb59f8814aaaf7aabdb8962294",
      "69d208d281a2e7bffd3eaf4bab2309b1",
      "ec05666cfb60211bedc5e81d4c1caf3d",
      "da520038c153f4054cb8cc5faa617714",
      "59906c8cd819cae67476baa90a36b8c1",
      "9a8fe78c588d08018843b64b57409a02",
      "8b5d28e985c0542163927d253a3e4fc9",
      "783299b98179cc725f9c46b5e3b5381f",
      "1a2b3fba1187c68d6a9bfa66854f3318",
      "391ff57b38d9ea6f3eeb3fe69ab539d3"
    ]
    for i, test in tests:
      let filename = testsDir / test.addFileExt("nim")
      let testHash = getMD5(readFile(filename).string)
      doAssert testHash == refHashes[i], "Nim in Action test " & filename &
          " was changed: " & $(i: i, testHash: testHash, refHash: refHashes[i])

  # Run the tests.
  for testfile in tests:
    test "tests/" & testfile & ".nim"
  let jsFile = "tests/niminaction/Chapter8/canvas/canvas_test.nim"
  testJS jsFile
  let cppFile = "tests/niminaction/Chapter8/sfml/sfml_test.nim"
  testCPP cppFile

# ------------------------- manyloc -------------------------------------------

proc findMainFile(dir: string): string =
  # finds the file belonging to ".nim.cfg"; if there is no such file
  # it returns the some ".nim" file if there is only one:
  const cfgExt = ".nim.cfg"
  result = ""
  var nimFiles = 0
  for kind, file in os.walkDir(dir):
    if kind == pcFile:
      if file.endsWith(cfgExt): return file[.. ^(cfgExt.len+1)] & ".nim"
      elif file.endsWith(".nim"):
        if result.len == 0: result = file
        inc nimFiles
  if nimFiles != 1: result.setLen(0)

proc manyLoc(r: var TResults, cat: Category, options: string) =
  for kind, dir in os.walkDir("tests/manyloc"):
    if kind == pcDir:
      when defined(windows):
        if dir.endsWith"nake": continue
      if dir.endsWith"named_argument_bug": continue
      let mainfile = findMainFile(dir)
      if mainfile != "":
        var test = makeTest(mainfile, options, cat)
        test.spec.action = actionCompile
        testSpec r, test

proc compileExample(r: var TResults, pattern, options: string, cat: Category) =
  for test in os.walkFiles(pattern):
    var test = makeTest(test, options, cat)
    test.spec.action = actionCompile
    testSpec r, test

proc testStdlib(r: var TResults, pattern, options: string, cat: Category) =
  var files: seq[string]

  proc isValid(file: string): bool =
    for dir in parentDirs(file, inclusive = false):
      if dir.lastPathPart in ["includes", "nimcache"]:
        # e.g.: lib/pure/includes/osenv.nim gives: Error: This is an include file for os.nim!
        return false
    let name = extractFilename(file)
    if name.splitFile.ext != ".nim": return false
    for namei in disabledFiles:
      # because of `LockFreeHash.nim` which has case
      if namei.cmpPaths(name) == 0: return false
    return true

  for testFile in os.walkDirRec(pattern):
    if isValid(testFile):
      files.add testFile

  files.sort # reproducible order
  for testFile in files:
    let contents = readFile(testFile).string
    var testObj = makeTest(testFile, options, cat)
    #[
    todo:
    this logic is fragile:
    false positives (if appears in a comment), or false negatives, e.g.
    `when defined(osx) and isMainModule`.
    Instead of fixing this, see https://github.com/nim-lang/Nim/issues/10045
    for a much better way.
    ]#
    if "when isMainModule" notin contents:
      testObj.spec.action = actionCompile
    testSpec r, testObj

# ----------------------------- nimble ----------------------------------------

var nimbleDir = getEnv("NIMBLE_DIR").string
if nimbleDir.len == 0: nimbleDir = getHomeDir() / ".nimble"
let
  nimbleExe = findExe("nimble")
  packageIndex = nimbleDir / "packages_official.json"

type
  PkgPart = enum
    ppOne
    ppTwo

iterator listPackages(part: PkgPart): tuple[name, cmd, url: string, useHead: bool] =
  let packageList = parseFile(packageIndex)
  let importantList =
    case part
    of ppOne: important_packages.packages1
    of ppTwo: important_packages.packages2
  for n, cmd, url, useHead in importantList.items:
    if url.len != 0:
      yield (n, cmd, url, useHead)
    else:
      var found = false
      for package in packageList.items:
        let name = package["name"].str
        if name == n:
          found = true
          let pUrl = package["url"].str
          yield (name, cmd, pUrl, useHead)
          break
      if not found:
        raise newException(ValueError, "Cannot find package '$#'." % n)

proc makeSupTest(test, options: string, cat: Category): TTest =
  result.cat = cat
  result.name = test
  result.options = options
  result.startTime = epochTime()

proc testNimblePackages(r: var TResults; cat: Category; packageFilter: string, part: PkgPart) =
  if nimbleExe == "":
    echo "[Warning] - Cannot run nimble tests: Nimble binary not found."
    return
  if execCmd("$# update" % nimbleExe) == QuitFailure:
    echo "[Warning] - Cannot run nimble tests: Nimble update failed."
    return

  let packageFileTest = makeSupTest("PackageFileParsed", "", cat)
  let packagesDir = "pkgstemp"
  createDir(packagesDir)
  var errors = 0
  try:
    for name, cmd, url, useHead in listPackages(part):
      if packageFilter notin name:
        continue
      inc r.total
      var test = makeSupTest(name, "", cat)
      let buildPath = packagesDir / name

      if not dirExists(buildPath):
        let (cloneCmd, cloneOutput, cloneStatus) = execCmdEx2("git", ["clone", url, buildPath])
        if cloneStatus != QuitSuccess:
          r.addResult(test, targetC, "", cloneCmd & "\n" & cloneOutput, reInstallFailed)
          continue

        if not useHead:
          let (fetchCmd, fetchOutput, fetchStatus) = execCmdEx2("git", ["fetch", "--tags"], workingDir = buildPath)
          if fetchStatus != QuitSuccess:
            r.addResult(test, targetC, "", fetchCmd & "\n" & fetchOutput, reInstallFailed)
            continue

          let (describeCmd, describeOutput, describeStatus) = execCmdEx2("git", ["describe", "--tags", "--abbrev=0"], workingDir = buildPath)
          if describeStatus != QuitSuccess:
            r.addResult(test, targetC, "", describeCmd & "\n" & describeOutput, reInstallFailed)
            continue

          let (checkoutCmd, checkoutOutput, checkoutStatus) = execCmdEx2("git", ["checkout", describeOutput.strip], workingDir = buildPath)
          if checkoutStatus != QuitSuccess:
            r.addResult(test, targetC, "", checkoutCmd & "\n" & checkoutOutput, reInstallFailed)
            continue

        let (installDepsCmd, installDepsOutput, installDepsStatus) = execCmdEx2("nimble", ["install", "--depsOnly", "-y"], workingDir = buildPath)
        if installDepsStatus != QuitSuccess:
          r.addResult(test, targetC, "", "installing dependencies failed:\n$ " & installDepsCmd & "\n" & installDepsOutput, reInstallFailed)
          continue

      let cmdArgs = parseCmdLine(cmd)

      let (buildCmd, buildOutput, status) = execCmdEx2(cmdArgs[0], cmdArgs[1..^1], workingDir = buildPath)
      if status != QuitSuccess:
        r.addResult(test, targetC, "", "package test failed\n$ " & buildCmd & "\n" & buildOutput, reBuildFailed)
      else:
        inc r.passed
        r.addResult(test, targetC, "", "", reSuccess)

    errors = r.total - r.passed
    if errors == 0:
      r.addResult(packageFileTest, targetC, "", "", reSuccess)
    else:
      r.addResult(packageFileTest, targetC, "", "", reBuildFailed)

  except JsonParsingError:
    echo "[Warning] - Cannot run nimble tests: Invalid package file."
    r.addResult(packageFileTest, targetC, "", "Invalid package file", reBuildFailed)
  except ValueError:
    echo "[Warning] - $#" % getCurrentExceptionMsg()
    r.addResult(packageFileTest, targetC, "", "Unknown package", reBuildFailed)
  finally:
    if errors == 0: removeDir(packagesDir)


# ----------------------------------------------------------------------------

const AdditionalCategories = ["debugger", "examples", "lib", "ic"]
const MegaTestCat = "megatest"

proc `&.?`(a, b: string): string =
  # candidate for the stdlib?
  result = if b.startsWith(a): b else: a & b

proc processSingleTest(r: var TResults, cat: Category, options, test: string) =
  let test = testsDir &.? cat.string / test
  let target = if cat.string.normalize == "js": targetJS else: targetC
  if fileExists(test):
    testSpec r, makeTest(test, options, cat), {target}
  else:
    doAssert false, test & " test does not exist"

proc isJoinableSpec(spec: TSpec): bool =
  result = not spec.sortoutput and
    spec.action == actionRun and
    not fileExists(spec.file.changeFileExt("cfg")) and
    not fileExists(spec.file.changeFileExt("nims")) and
    not fileExists(parentDir(spec.file) / "nim.cfg") and
    not fileExists(parentDir(spec.file) / "config.nims") and
    spec.cmd.len == 0 and
    spec.err != reDisabled and
    not spec.unjoinable and
    spec.exitCode == 0 and
    spec.input.len == 0 and
    spec.nimout.len == 0 and
    spec.outputCheck != ocSubstr and
    spec.ccodeCheck.len == 0 and
    (spec.targets == {} or spec.targets == {targetC})
  if result:
    if spec.file.readFile.contains "when isMainModule":
      result = false

proc norm(s: var string) =
  while true:
    let tmp = s.replace("\n\n", "\n")
    if tmp == s: break
    s = tmp
  s = s.strip

proc quoted(a: string): string =
  # todo: consider moving to system.nim
  result.addQuoted(a)

proc runJoinedTest(r: var TResults, cat: Category, testsDir: string) =
  ## returns a list of tests that have problems
  var specs: seq[TSpec] = @[]
  for kind, dir in walkDir(testsDir):
    assert testsDir.startsWith(testsDir)
    let cat = dir[testsDir.len .. ^1]
    if kind == pcDir and cat notin specialCategories:
      for file in walkDirRec(testsDir / cat):
        if isTestFile(file):
          let spec = parseSpec(file)
          if isJoinableSpec(spec):
            specs.add spec

  proc cmp(a: TSpec, b:TSpec): auto = cmp(a.file, b.file)
  sort(specs, cmp=cmp) # reproducible order
  echo "joinable specs: ", specs.len

  if simulate:
    var s = "runJoinedTest: "
    for a in specs: s.add a.file & " "
    echo s
    return

  var megatest: string
  # xxx (minor) put outputExceptedFile, outputGottenFile, megatestFile under here or `buildDir`
  var outDir = nimcacheDir(testsDir / "megatest", "", targetC)
  const marker = "megatest:processing: "

  for i, runSpec in specs:
    let file = runSpec.file
    let file2 = outDir / ("megatest_$1.nim" % $i)
    # `include` didn't work with `trecmod2.nim`, so using `import`
    let code = "echo \"$1\", $2\n" % [marker, quoted(file)]
    createDir(file2.parentDir)
    writeFile(file2, code)
    megatest.add "import $1\nimport $2\n" % [quoted(file2), quoted(file)]

  let megatestFile = testsDir / "megatest.nim" # so it uses testsDir / "config.nims"
  writeFile(megatestFile, megatest)

  let root = getCurrentDir()
  let args = ["c", "--nimCache:" & outDir, "-d:testing", "--listCmd", "--path:" & root, megatestFile]
  var (cmdLine, buf, exitCode) = execCmdEx2(command = compilerPrefix, args = args, input = "")
  if exitCode != 0:
    echo "$ " & cmdLine & "\n" & buf.string
    quit(failString & "megatest compilation failed")

  (buf, exitCode) = execCmdEx(megatestFile.changeFileExt(ExeExt).dup normalizeExe)
  if exitCode != 0:
    echo buf.string
    quit(failString & "megatest execution failed")

  norm buf.string
  const outputExceptedFile = "outputExpected.txt"
  const outputGottenFile = "outputGotten.txt"
  writeFile(outputGottenFile, buf.string)
  var outputExpected = ""
  for i, runSpec in specs:
    outputExpected.add marker & runSpec.file & "\n"
    outputExpected.add runSpec.output.strip
    outputExpected.add '\n'
  norm outputExpected

  if buf.string != outputExpected:
    writeFile(outputExceptedFile, outputExpected)
    discard execShellCmd("diff -uNdr $1 $2" % [outputExceptedFile, outputGottenFile])
    echo failString & "megatest output different!"
    # outputGottenFile, outputExceptedFile not removed on purpose for debugging.
    quit 1
  else:
    echo "megatest output OK"
    when false: # no point removing those, always good for debugging
      removeFile(outputGottenFile)
      removeFile(megatestFile) # keep it around
  #testSpec r, makeTest("megatest", options, cat)

# ---------------------------------------------------------------------------

proc processCategory(r: var TResults, cat: Category,
                     options, testsDir: string,
                     runJoinableTests: bool) =
  case cat.string.normalize
  of "ic":
    when false:
      icTests(r, testsDir, cat, options)
  of "js":
    # only run the JS tests on Windows or Linux because Travis is bad
    # and other OSes like Haiku might lack nodejs:
    if not defined(linux) and isTravis:
      discard
    else:
      jsTests(r, cat, options)
  of "dll":
    dllTests(r, cat, options)
  of "flags":
    flagTests(r, cat, options)
  of "gc":
    gcTests(r, cat, options)
  of "longgc":
    longGCTests(r, cat, options)
  of "debugger":
    debuggerTests(r, cat, options)
  of "manyloc":
    manyLoc r, cat, options
  of "threads":
    threadTests r, cat, options & " --threads:on"
  of "io":
    ioTests r, cat, options
  of "async":
    asyncTests r, cat, options
  of "lib":
    testStdlib(r, "lib/pure/", options, cat)
    testStdlib(r, "lib/packages/docutils/", options, cat)
  of "examples":
    compileExample(r, "examples/*.nim", options, cat)
    compileExample(r, "examples/gtk/*.nim", options, cat)
    compileExample(r, "examples/talk/*.nim", options, cat)
  of "nimble-packages-1":
    testNimblePackages(r, cat, options, ppOne)
  of "nimble-packages-2":
    testNimblePackages(r, cat, options, ppTwo)
  of "niminaction":
    testNimInAction(r, cat, options)
  of "untestable":
    # We can't test it because it depends on a third party.
    discard # TODO: Move untestable tests to someplace else, i.e. nimble repo.
  of "megatest":
    runJoinedTest(r, cat, testsDir)
  else:
    var testsRun = 0
    var files: seq[string]
    for file in walkDirRec(testsDir &.? cat.string):
      if isTestFile(file): files.add file
    files.sort # give reproducible order

    for i, name in files:
      var test = makeTest(name, options, cat)
      if runJoinableTests or not isJoinableSpec(test.spec) or cat.string in specialCategories:
        discard "run the test"
      else:
        test.spec.err = reJoined
      testSpec r, test
      inc testsRun
    if testsRun == 0:
      echo "[Warning] - Invalid category specified \"", cat.string, "\", no tests were run"

proc processPattern(r: var TResults, pattern, options: string; simulate: bool) =
  var testsRun = 0
  if dirExists(pattern):
    for k, name in walkDir(pattern):
      if k in {pcFile, pcLinkToFile} and name.endsWith(".nim"):
        if simulate:
          echo "Detected test: ", name
        else:
          var test = makeTest(name, options, Category"pattern")
          testSpec r, test
        inc testsRun
  else:
    for name in walkPattern(pattern):
      if simulate:
        echo "Detected test: ", name
      else:
        var test = makeTest(name, options, Category"pattern")
        testSpec r, test
      inc testsRun
  if testsRun == 0:
    echo "no tests were found for pattern: ", pattern
