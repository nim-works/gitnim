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
  gitnimDebug {.booldefine.} = false
  defaultProcess = {poStdErrToStdOut, poParentStreams}
  capture = {poStdErrToStdOut}

proc originURL(): string {.compileTime.} =
  ## guess the origin url for automatic embed
  let url = parseUri staticExec"git remote get-url origin"
  if url.path.startsWith "/":
    result = $url
  else:
    result = "(origin url unknown)"

# these will change towards our nightlies soon
const
  binsURL: string = "NIM_BINS"
  embBINS: string = originURL()
  bins {.used, strdefine.}: string = getEnv(binsURL, embBINS)

# use the above to guess the distribution URL
proc toDist(u: string): string {.compileTime.} =
  var url = parseUri u
  # support for paths is inconsistent, so we do this simply
  if url.hostname != "":
    # it's a URL; use a peer of the gitnim repo
    url.path = parentDir url.path
  if not url.path.endsWith "/":
    url.path.add "/"
  url.path.add "dist"
  result = $url

const
  distURL: string = "NIM_DIST"
  embDIST: string = bins.toDist
  dist {.used, strdefine.}: string = getEnv(distURL, embDIST)
  dir = "dist"

static:
  hint "gitnim uses following nightlies repository:"
  hint bins
  hint "via setting the $" & binsURL & ", or"
  hint "via passing --define:bins=\"...\""
  hint "gitnim uses the following distribution url:"
  hint dist
  hint "via setting the $" & distURL & ", or"
  hint "via passing --define:dist=\"...\""

template distribution(): string =
  ## the current distribution URL
  getEnv(distURL, dist)

type
  RunOutput = object
    arguments: seq[string]
    output: string
    ok: bool

macro repo(): untyped =
  let getEnv = bindSym"getEnv"
  result = getEnv.newCall(binsURL.newLit, embBINS.newLit)

template crash(why: string) {.used.} =
  error why
  quit 1

template withinDirectory(path: typed; body: untyped) =
  ## do something within a particular directory
  if dirExists $(path):
    let cwd = getCurrentDir()
    when gitnimDebug:
      debug "setCurrentDir $#" % [ $(path) ]
    setCurrentDir $(path)
    try:
      body
    finally:
      when gitnimDebug:
        debug "setCurrentDir $#" % [ cwd ]
      setCurrentDir cwd
  else:
    raise newException(ValueError, $path & " is not a directory")

let nimDirectory = parentDir getAppDir()
template withinNimDirectory(body: untyped) =
  withinDirectory nimDirectory:
    body

template withinDistribution(body: untyped) =
  ## do something within the distribution directory
  let dist = nimDirectory / dir
  withinNimDirectory:
    if dirExists dist:
      if fileExists dist / ".git":
        withinDirectory dist:
          body

proc run(exe: string; args: openArray[string];
         options = defaultProcess): RunOutput =
  ## run a program with arguments
  var
    command = findExe(exe)
    arguments: seq[string] = @args
    opts = options

  block ran:
    if command == "":
      result = RunOutput(output: "unable to find $# in path" % [ exe ])
      warn result.output
      break ran

    when gitnimDebug:
      debug command, arguments.join(" ")

    if poParentStreams in opts or poInteractive in opts:
      # sorry; i just find this easier to read than union()
      opts.incl poInteractive
      opts.incl poParentStreams
      # the user wants interactivity
      let process = startProcess(command, args = arguments, options = opts)
      result = RunOutput(ok: process.waitForExit == 0)
      when gitnimDebug:
        debug $process.waitForExit
    else:
      var execute = join(@[command] & arguments, " ")
      let (output, code) = execCmdEx(execute, options = opts)
      result = RunOutput(ok: code == 0, output: output)
      when gitnimDebug:
        debug $code

    # for utility, also return the arguments we used
    result.arguments = arguments

    # a failure is worth noticing
    if not result.ok:
      notice exe & " " & arguments.join(" ")

proc git(args: openArray[string]; options = capture): string
  {.discardable.} =
  ## run git with some arguments
  var also = @args
  if stdout.isAtty and args.anyIt it.startsWith("--sort"):
    also.insert("--color", 1)
  let ran = run("git", also, options = options)
  if ran.ok:
    result = ran.output
  else:
    crash ran.output

proc git(args: string; options = capture): string
  {.discardable.} =
  ## run git with some arguments
  git(args.split, options = options)

proc currentNimBranch(): string =
  withinNimDirectory:
    result = git(["branch", "--show-current",
                  "--format=%(objectname)"])
  if result == "":
    crash "unable to determine branch"

proc currentNimVersion(): string =
  ## kinda brittle, but what can you do?
  withinNimDirectory:
    let ran = run("bin" / "nim", ["--version"], capture)
    if not ran.ok:
      crash "unable to determine nim version"
    else:
      #Nim Compiler Version 1.5.1 [Linux: amd64]
      let header = splitLines(ran.output)[0]
      result = splitWhitespace(header)[3]

proc nim(args: openArray[string]; options = defaultProcess): string =
  ## run nim with some arguments
  run(findExe"nim", args, options = options).output

template refreshDistribution() =
  withinDistribution:
    let branch = currentNimVersion()
    let ran = run("git", ["checkout", branch], capture)
    if ran.ok:
      info "using the $# distribution branch" % [ branch ]
    else:
      warn "the $# distribution branch is not available" % [ branch ]
      notice ran.output

template repointDistribution() =
  withinDistribution:
    for kind, package in walkDir".":
      let module = lastPathPart package
      if kind == pcDir and not module.startsWith("."):
        if fileExists package / ".git":
          stderr.write "."
          git ["submodule", "update", "--init", module]
        else:
          stderr.write "+"
          git ["submodule", "update", "--init", "--depth=1", module]
    stderr.write "\n"

proc switch(branch: string): bool =
  ## switch compiler and distribution branches
  withinNimDirectory:
    let switch = run("git", ["checkout", branch], capture)
    result = switch.ok
    if result:
      info "using the $# compiler branch" % [ branch ]
      refreshDistribution()
      repointDistribution()
    else:
      warn switch.output

proc refresh() =
  withinNimDirectory:
    git "fetch --all"
    let dist = "dist"
    if not dirExists dist:
      createDir dist
      git ["submodule", "add", distribution().quoteShell, dist ]
    elif not dirExists ".git" / "modules" / dist:
      git ["submodule", "update", "--init", dist]
    elif not fileExists dist / ".gitmodules":
      git ["submodule", "update", "--init", dist]
  withinDistribution:
    info "querying for new distributions..."
    git "fetch --all --prune"
    refreshDistribution()
    info "fetching the current distribution..."
    git "pull --rebase=merges --autostash"
    repointDistribution()

when isMainModule:
  let logger = newCuteConsoleLogger()
  addHandler logger

  let app = extractFilename getAppFilename()
  info "$1 on $2 for Nim $3" % [ app, repo(), NimVersion ]

  if paramCount() == 0:
    refresh()
    withinNimDirectory:
      info "specify a branch; eg. `git nim 1.2.2` or `git nim origin/1.0.7`:"
      info git "branch --all --sort=version:refname --verbose"
      info "or you can specify one of these tags; eg. `git nim latest`:"
      info git "tag --list -n2 --sort=version:refname"
  else:
    if switch paramStr(1):
      info nim ["--version"]
