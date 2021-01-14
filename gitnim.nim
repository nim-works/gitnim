import std/options
import std/sequtils
import std/macros except `error`
import std/os
import std/strutils
import std/osproc
import std/logging
import std/uri
import std/terminal
import std/parsecfg

import cutelog

const
  gitnimDebug {.used,booldefine.} = false
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
  error why
  quit 1

template changeDir(path: string) =
  let cwd = getCurrentDir()
  when gitnimDebug:
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
  withinNimDirectory:
    if dirExists dist:
      if fileExists dist / ".git":
        withinDirectory dist:
          body

proc parseModules(): Option[Config] =
  ## parse a .gitmodules file using the stdlib's .ini parser;
  ## returns an empty Option in any failure event
  withinDistribution:
    if ".gitmodules".fileExists:
      let cfg = loadConfig ".gitmodules"
      if not cfg.isNil:
        result = some cfg

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
    when gitnimDebug:
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

    result.ok = code == 0
    when gitnimDebug:
      if not result.ok:
        debug $code

    # for utility, also return the arguments we used
    result.arguments = arguments

    # a failure is worth noticing
    if not result.ok:
      notice exe & " " & arguments.join(" ")

proc git(args: openArray[string]; options = capture): string {.discardable.} =
  ## run git with some arguments
  var also = @args
  if stdout.isAtty and args.anyIt it.startsWith("--sort"):
    also.insert("--color", 1)
  let ran = run("git", also, options = options)
  if ran.ok:
    result = ran.output
  else:
    crash ran.output

proc git(args: string; options = capture): string {.discardable.} =
  ## run git with some arguments
  git(split args, options = options)

proc currentBranch(): string =
  ## find the current branch; note that you must choose the directory
  result = strip git"branch --show-current --format='%(objectname)'"
  if result == "":
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

proc setupDistribution(): bool =
  ## true if we had to setup the distribution from scratch
  withinNimDirectory:
    if not dist.dirExists:
      createDir dist
      git ["submodule", "add", distribution().quoteShell, dist ]
    else:
      if dirExists ".git" / "modules" / dist:
        if fileExists dist / ".gitmodules":
          return false
      git ["submodule", "update", "--init", dist]
    result = true

proc repointDistribution(fetch = "--checkout") =
  ## make sure the submodules point to the current versions
  withinDistribution:
    for kind, package in walkDir".":
      let module = lastPathPart package
      if kind == pcDir and not module.startsWith("."):
        when gitnimDebug:
          if module != "gram":
            continue
        if fileExists package / ".git":
          stderr.write "."
          git ["submodule", "update", fetch, module]
        else:
          stderr.write "+"
          git ["submodule", "update", "--init", "--depth=1", module]
    stderr.write "\n"

proc switchDistribution(): bool =
  ## target the distribution at the current compiler version
  withinDistribution:
    let branch = currentNimVersion()
    var ran = run("git", ["checkout", "origin/" & branch])
    if not ran.ok:
      ran = run("git", ["fetch", "--prune", "origin", branch])
      if ran.ok:
        ran = run("git", ["checkout", "origin/" & branch])
    result = ran.ok
    if result:
      info "using the $# distribution branch" % [ branch ]
    else:
      warn "the $# distribution branch is not available" % [ branch ]
      notice ran.output

proc switch(branch: string): bool =
  ## switch compiler and distribution branches; returns true on success
  withinNimDirectory:
    let switch = run("git", ["checkout", branch])
    result = switch.ok
    if result:
      info "using the $# compiler branch" % [ branch ]
      if switchDistribution():
        # make sure all the modules point to the right version
        repointDistribution "--checkout"
    else:
      warn switch.output

proc refreshDistribution(): bool =
  withinNimDirectory:
    let branch = currentBranch()
    info "refreshing the $# distribution..." % [ branch ]
    withinDistribution:
      discard run("git", ["fetch", "origin", branch])
      result = switchDistribution()

proc refresh() =
  ## check the network for fresh releases of Nim or the distribution
  withinNimDirectory:
    info "refreshing available Nim releases..."
    git"fetch --all"
    # see if we need to setup the distribution and if so,
    discard setupDistribution()
    withinDistribution:
      if refreshDistribution():
        # make sure all the modules point to the right version
        repointDistribution "--checkout"

when isMainModule:
  let logger = newCuteConsoleLogger()
  addHandler logger

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
          info git"branch --all --sort=version:refname --verbose"
          info "or you can specify one of these tags; eg. `git nim latest`:"
          info git"tag --list -n2 --sort=version:refname"
          when gitnimDebug:
            withinDistribution:
              info git"branch --all --sort=version:refname --verbose"
              info git"tag --list -n2 --sort=version:refname"
      else:
        # the user knows what they want; give it to them with as little
        # latency as possible and then display the nim version
        if switch paramStr(1):
          info nim"--version"
