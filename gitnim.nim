import std/tables
import std/algorithm
import std/deques
import std/options
import std/sequtils
import std/macros except `error`
import std/os
import std/strutils
import std/osproc
import std/logging
import std/uri
import std/terminal

import cutelog

const
  mainBranches = ["main", "master"]
  interact {.used.} = {poStdErrToStdOut, poParentStreams}
  capture {.used.} = {poStdErrToStdOut}

proc originURL(): string {.compileTime.} =
  ## guess the origin url for automatic embed
  let url = parseUri staticExec"git remote get-url origin"
  if url.path.startsWith "/":
    result = $url
  else:
    result = "(origin url unknown)"

# these will change towards our nightlies soon
const
  binsENV: string = "NIM_BINS"
  embBINS: string = originURL()
  binsURL {.used, strdefine.}: string = getEnv(binsENV, embBINS)
  dist = "dist"
  attic = ".attic"

# use the above to guess the distribution URL
proc toDist(u: string): string {.compileTime.} =
  var url = parseUri u
  # support for paths is inconsistent, so we do this simply
  if url.hostname != "":
    # it's a URL; use a peer of the gitnim repo
    url.path = parentDir url.path
  if not url.path.endsWith "/":
    url.path.add "/"
  url.path.add dist
  result = $url

const
  distENV: string = "NIM_DIST"
  embDIST: string = binsURL.toDist
  distURL {.used, strdefine.}: string = getEnv(distENV, embDIST)

static:
  hint "gitnim uses the following binary releases:"
  hint binsURL
  hint "via setting the $" & binsENV & ", or"
  hint "via passing --define:binsURL=\"...\""
  hint "gitnim uses the following distribution url:"
  hint distURL
  hint "via setting the $" & distENV & ", or"
  hint "via passing --define:distURL=\"...\""

proc distribution(): string =
  ## the current distribution URL
  getEnv(distENV, distURL)

type
  RunOutput = object
    arguments: seq[string]
    output: string
    ok: bool

macro repo(): untyped =
  let getEnv = bindSym"getEnv"
  result = getEnv.newCall(binsENV.newLit, embBINS.newLit)

proc crash(why: string) {.used.} =
  when defined(debug):
    writeStackTrace()
  error why
  quit 1

template changeDir(path: string) =
  let cwd = getCurrentDir()
  if cwd != path:
    debug "cd " & path
  setCurrentDir path

template withinDirectory(path: string; body: typed) =
  ## do something within a particular directory
  if dirExists $(path):
    let prior = getCurrentDir()
    changeDir path
    try:
      body
    finally:
      changeDir prior
  else:
    raise newException(ValueError, $path & " is not a directory")

let nimDirectory = parentDir getAppDir()
template withinNimDirectory(body: typed) =
  withinDirectory nimDirectory:
    body

template withinDistribution(body: typed) =
  ## do something within the distribution directory
  let dist = nimDirectory / dist
  if dirExists dist:
    if fileExists dist / ".git":
      withinDirectory dist:
        body

proc run(exe: string; args: openArray[string];
         options = capture): RunOutput =
  ## run a program with arguments
  var
    command = findExe exe
    arguments: seq[string] = @args
    opts = options

  if command == "":
    result.output = "unable to find $# in path" % [ exe ]
    warn result.output
  else:
    debug command, arguments.join(" ")

    var code: int
    if poParentStreams in opts or poInteractive in opts:
      # sorry; i just find this easier to read than union()
      opts.incl poInteractive
      opts.incl poParentStreams
      # the user wants interactivity
      let process = startProcess(command, args = arguments, options = opts)
      code = process.waitForExit
    else:
      let execute = join(@[command] & arguments, " ")
      (result.output, code) = execCmdEx(execute, options = opts)

    # strip the output so newlines aren't too excessive
    result.output = strip(result.output, leading = false, trailing = true)
    # restore a single newline if necessary
    if result.output.len > 0:
      result.output.add "\n"

    result.ok = code == 0
    if not result.ok:
      debug $code

    # for utility, also return the arguments we used
    result.arguments = arguments

    # a failure is worth noticing
    if not result.ok:
      notice exe & " " & arguments.join(" ")

proc maybeStripColor(args: openArray[string]): seq[string] =
  result = @args
  if not stdout.isAtty:
    result = filterIt result: it != "--color"
    if "--no-color" notin result:
      result.insert("--no-color", 1)

proc git(args: openArray[string]; options = capture): string {.discardable.} =
  ## run git with some arguments
  let also = maybeStripColor args
  let ran = run("git", also, options = options)
  if ran.ok:
    result = ran.output
  else:
    crash ran.output

proc git(args: string; options = capture): string {.discardable.} =
  ## run git with some arguments
  git(split args, options = options)

type
  # a line of output from `git submodule`
  Module = object
    status: Status
    name: string
    sha: string

  # first character from the above
  Status = enum
    Missing   = "-"
    OutOfDate = "+"
    UpToDate  = " "

# for sorting
proc `<`(a, b: Module): bool = a.name < b.name
proc `==`(a, b: Module): bool = a.name == b.name

proc fetchFlag(b: bool): string =
  if b: "--checkout" else: "--no-fetch"

proc parseModules(): seq[Module] =
  ## get the list of modules, commits, etc. from `git submodule`;
  ## the result will be sorted by module name
  withinDistribution:
    for line in splitLines git"submodule":
      # status, 40-char sha, space, 2-letter (at least) package name
      if line.len >= 1+40+1+2:
        try:
          let status = parseEnum[Status]($line[0])
          let splat = split line[1..^1]
          result.add Module(status: status, name: splat[1], sha: splat[0])
          continue
        except:
          discard
        warn "weird `git submodule` output: " & line
    # don't trust git here; it's important that the result is sorted
    sort result

proc fetchFromAttic(module: string): bool =
  ## true if we were able to retrieve a module from the attic
  withinDistribution:
    if not dirExists module:
      if dirExists attic / module:
        debug "recovering " & module & " from " & attic
        moveDir attic / module, module
        result = true
      if not result:
        debug "unable to fetch " & module & " from " & attic

proc stashInAttic(module: string) =
  withinDistribution:
    createDir attic
    if dirExists attic / module:
      debug "removing " & module & " from " & attic
      removeDir attic / module
    debug "stashing " & module & " in " & attic
    moveDir module, attic / module

proc exposedModules(): Deque[string] =
  ## these are modules that the user can import by name;
  ## they are sorted by name
  withinDistribution:
    var available: seq[string]
    for kind, package in walkDir".":
      if kind == pcDir:
        let module = lastPathPart package
        # obviously, it can't start with a period
        if not module.startsWith ".":
          available.add module
    # 'member i said we'd sort them by name?
    sort available
    # i guess we write whens against the major/minor now
    # because it's too much work to port the stdlib to 1.2.
    when (NimMajor, NimMinor) >= (1, 3):
      result = available.toDeque
    else:
      result = initDeque[string]()
      for module in available.items:
        result.addLast module

proc update(m: Module; fetch = on) =
  withinDistribution:
    debug "update " & m.name
    stderr.write $m.status
    if fileExists m.name / ".git":
      git ["submodule", "update", fetchFlag fetch, m.name]
    else:
      git ["submodule", "update", "--init", "--depth=1", m.name]

proc toggleModules(fetch = on) =
  ## expose or hide modules according to .gitmodules;
  ## setting fetch to `off` indicates that you don't
  ## want to use the network to update out-of-date modules,
  ## but we always add missing modules via the network.
  withinDistribution:
    debug "toggling modules with " & fetchFlag fetch
    # the attic is a place to store modules we aren't using
    createDir attic

    # see if we need to fetch anything we might want from the attic
    var modules = parseModules()
    var dirty = false
    for m in modules.items:
      dirty = fetchFromAttic(m.name) or dirty
    if dirty:
      # if we moved something into place, ask git to update the list
      # so we have current data on module status and commit
      modules = parseModules()

    # get the modules that are currently exposed to the user
    var exposed = exposedModules()

    # update anything that needs updating, in an appropriate way
    for m in modules.items:
      case m.status
      of UpToDate:
        discard
      of OutOfDate:
        m.update(fetch = fetch)         # resist network?
      of Missing:
        m.update(fetch = on)            # use the network

      # stash anything we don't need in the attic
      while exposed.len > 0:
        if exposed[0] < m.name:
          stashInAttic popFirst(exposed)     # hide it
        elif exposed[0] == m.name:
          popFirst(exposed)                  # ignore it
          break
        else:
          break                              # we're done
    stderr.write "\n"

    # anything remaining goes to the attic, of course
    while exposed.len > 0:
      stashInAttic popFirst(exposed)

proc parseBranches(input: string): Table[string, string] =
  ## parse some git output into a table of ref->sha | sha->ref
  let input = strip input
  var sha, path: string   # store the sha as a string because lazy
  for line in input.splitLines(keepEol = false):
    when true:
      (sha, path) = line.split(' ', maxsplit = 1)
      if path == "":
        crash "unable to parse git output\n" & line
    else:
      # the scanf call is broken on 1.0 🙄
      if not scanf(line, "$+ $+$.", sha, path):
        crash "unable to parse git output\n" & line
    # NOTE: we overwrite a HEAD with a proper branch here;
    #       and we map in both directions because why not
    result[path] = sha
    result[sha] = path

proc currentBranch(): string =
  ## find the current branch; note that you must choose the directory
  let parsed =
    parseBranches:
      git"branch --sort=refname --format='%(objectname) %(refname)'"
  let sha = strip git"rev-parse --verify HEAD"
  try:
    result = parsed[sha].lastPathPart
    debug "the current branch of " & getCurrentDir() & " is " & result
  except KeyError:
    crash "unable to determine branch"

proc nim(args: string; options = capture): string =
  ## run nim with some arguments
  withinNimDirectory:
    let nim = "bin" / "nim"
    if not nim.fileExists:
      crash "unable to find nim and unwilling to search your path"
    else:
      let ran = run(nim, split args, options = options)
      if not ran.ok:
        crash ran.output
      else:
        result = ran.output

proc currentNimVersion(): string =
  ## kinda brittle, but what can you do?
  withinNimDirectory:
    var version = nim"--version"
    #Nim Compiler Version 1.5.1 [Linux: amd64]
    if not version.startsWith "Nim Compiler Version ":
      crash "unable to determine nim version"
    else:
      version = splitLines(version)[0]
      result = splitWhitespace(version)[3]
      debug "this is nim version " & result

proc setupDistribution(): bool =
  ## true if we had to setup the distribution from scratch
  withinNimDirectory:
    if not dist.dirExists:
      createDir dist
      git ["submodule", "add", distribution().quoteShell, dist ]
    else:
      if dirExists ".git" / "modules" / dist:
        if fileExists dist / ".gitmodules":
          debug "the distribution is already setup"
          result = false
          return
          #return false      # amazingly, this doesn't work on 1.2
      git ["submodule", "update", "--init", dist]
    result = true
    debug "initialized the distribution"

proc repointDistribution(fetch = on) {.deprecated.} =
  ## make sure the submodules point to the current versions
  withinDistribution:
    for kind, package in walkDir".":
      let module = lastPathPart package
      if kind == pcDir and not module.startsWith("."):
        if fileExists package / ".git":
          stderr.write "."
          git ["submodule", "update", fetchFlag fetch, module]
        else:
          stderr.write "+"
          git ["submodule", "update", "--init", "--depth=1", module]
    stderr.write "\n"

proc dumpLog(a, b: string) =
  ## output the git log for the commits between refs `a` and `b`
  if a != b:
    let log = git ["log", "--pretty='format:%Cblue%>(14)%ar %Cgreen%s'",
                   "--reverse", a & "..." & b]
    if strip(log).len == 0:
      info "(no updates)"
    else:
      info log

proc checkoutDistribution(branch: string; fetch = on): RunOutput =
  withinDistribution:
    let current = currentBranch()
    result = run("git", ["checkout", branch])
    # if we want to fetch or the branch doesn't exist,
    if fetch or not result.ok:
      # point to the origin and try to fetch again
      result = run("git", ["fetch", "--prune", "origin", branch])
      if result.ok:
        # if that worked, we dump the log to show changes,
        dumpLog current, "origin/" & branch
        # pull those changes from the network,
        result = run("git", ["pull", "--rebase=merges", "--autostash"])
        if result.ok:
          # and attempt to checkout the branch again
          result = run("git", ["checkout", branch])

proc switchDistribution(branch = "", fetch = on): bool =
  ## target the distribution at the current compiler version
  withinDistribution:
    let branch =
      if branch == "":
        currentNimVersion()
      else:
        branch
    var ran = checkoutDistribution(branch, fetch)
    result = ran.ok
    if result:
      debug "using the $# distribution branch" % [ branch ]
    else:
      warn "the $# distribution branch is not available" % [ branch ]
      notice ran.output

proc switch(branch: string): bool =
  ## switch compiler and distribution branches; returns true on success
  withinNimDirectory:
    let switch = run("git", ["checkout", branch])
    result = switch.ok
    if result:
      debug "using the $# compiler branch" % [ branch ]
      # we're switching the compiler, so there's no way to guess which
      # custom distribution the user might want -- just switch to the
      # distribution that matches the new compiler version
      if switchDistribution(currentNimVersion(), fetch = off):
        # gently repoint all the modules to the right version
        toggleModules(fetch = off)
    else:
      warn switch.output

proc refresh() =
  ## check the network for fresh releases of Nim or the distribution
  withinNimDirectory:
    info "refreshing available Nim releases..."
    git"fetch --all"
    # see if we need to setup the distribution and if so,
    discard setupDistribution()
    let nim = currentNimVersion()
    withinDistribution:
      # if we're in the main branch, then presume that we actually
      # want to point at the branch that matches the compiler version
      var branch = currentBranch()
      if branch in mainBranches:
        branch = nim
      info "refreshing the $# distribution..." % [ branch ]
      discard run("git", ["fetch", "origin", branch])
      # we're not using a custom distribution branch, so we'll go
      # ahead and toggle the modules to ensure they are fresh
      if switchDistribution(branch, fetch = on):
        # make sure all the modules point to the right version
        toggleModules(fetch = on)

proc install() =
  ## perform an automatic installation because nimble is dumb
  ## and stomps all over our --outdir configuration setting
  let nim = findExe"nim"
  if nim == "":
    return         # there's a good chance we're out of our depth, here

  let nimbin = nim.parentDir
  withinDirectory nimbin:
    let app = getAppFilename()
    let bin = nimbin / extractFilename app
    # sameFile can be kinda expensive, so try not to call it
    if app != bin:
      if not bin.fileExists or not sameFile(app, bin):
        debug app & " is not the same as " & bin & "; install ourselves"
        try:
          moveFile app, bin
        except OSError as e:
          warn "failed to move " & app & " to " & nimbin
          warn "unable to install: " & e.msg
          quit 1

        debug "move successful; invoke app from new location"
        # let an OSError raise normally; not much we can add to a message
        quit:
          waitForExit:
            startProcess(bin, args = commandLineParams(), options = interact)

when isMainModule:
  let logger = newCuteConsoleLogger()
  addHandler logger
  setLogFilter:
    when defined(debug):
      lvlDebug
    else:
      lvlInfo

  install()  # install ourselves if necessary; noreturn in that event

  let app = extractFilename getAppFilename()
  info "$1 against $2" % [ app, repo() ]

  withinNimDirectory:
    if not ".git".dirExists:
      # we want to handle degraded environments gracefully...
      if ".git".fileExists:
        warn app & " cowardly refusing to manage a Nim submodule"
      else:
        warn app & " works best against Nim from a git repository"
      if not stderr.isAtty:
        notice app & " will assume a headless/CI context..."
    else:
      # this is the expected path, wherein we likely have a git repo
      if paramCount() == 0:
        # no arguments means the user wants to see what's available;
        # perform a network refresh and then display their options
        refresh()
        withinNimDirectory:
          info "specify a branch; eg. `git nim 1.2.2` or `git nim origin/1.0.7`:"
          info git"branch --color --all --sort=version:refname --verbose"
          info "or you can specify one of these tags; eg. `git nim latest`:"
          info git"tag --color --list -n2 --sort=version:refname"
      else:
        # the user knows what they want; give it to them with as little
        # latency as possible and then display the nim version
        if switch paramStr(1):
          info nim"--version"
