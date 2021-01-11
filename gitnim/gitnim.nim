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

# these will change towards our nightlies soon
const
  envURL: string = "GITNIM_URL"
  embURL: string = staticExec"git remote get-url origin"
  URL {.strdefine.}: string = getEnv(envURL, embURL)

# use the above to guess the distribution URL
proc toDist(u: string): string {.compileTime.} =
  var url = parseUri(u)
  url.path = parentDir(url.path) / "dist"
  result = $url

const
  distURL: string = "NIM_DIST"
  embDist: string = embURL.toDist
  dist {.strdefine.}: string = getEnv(distURL, embDIST)

static:
  hint "gitnim uses following url by default:"
  hint URL
  hint "via setting the $" & envURL & ", or"
  hint "via passing --define:URL=\"...\""
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
  result = getEnv.newCall(envURL.newLit, URL.newLit)

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

template withinDistribution(body: untyped) =
  ## do something within the distribution directory
  let dist = getAppDir().parentDir / "dist"
  if dirExists dist:
    if fileExists dist / ".git":
      withinDirectory dist:
        body

proc run(exe: string; args: openArray[string];
         options = defaultProcess): RunOutput =
  ## run a program with arguments
  var
    command = findExe(exe)
    arguments: seq[string]
    opts = options
  for a in args:
    arguments.add a
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
      let process = startProcess(command, getAppDir(),
                                 args = arguments, options = opts)
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

proc git(args: openArray[string]; options = defaultProcess): string
  {.discardable.} =
  ## run git with some arguments
  var also = @args
  if stdout.isAtty and args.anyIt "--sort" in it:
    also.insert("--color", 1)
  let ran = run("git", also, options = options)
  if ran.ok:
    result = ran.output
  else:
    crash ran.output

proc git(args: string; options = defaultProcess): string
  {.discardable.} =
  ## run git with some arguments
  git(args.split, options = options)

proc nim(args: openArray[string]; options = defaultProcess): string =
  ## run nim with some arguments
  run(findExe"nim", args, options = options).output

proc refresh() =
  discard git("fetch --all")
  withinDirectory getAppDir().parentDir:
    let dist = "dist"
    if not dirExists dist:
      createDir dist
      git("submodule add --depth 1 $1 dist" % [ distribution().quoteShell ])
  withinDistribution:
    git("fetch --all --prune")
    git("pull")

proc switch(branch: string): bool =
  ## switch compiler and distribution branches
  withinDirectory getAppDir().parentDir:
    let switch = run("git", ["checkout", branch], {poStdErrToStdOut})
    result = switch.ok
    if result:
      info "using the $1 compiler branch" % [ branch ]
      withinDistribution:
        if run("git", ["checkout", branch], {poStdErrToStdOut}).ok:
          info "using the $1 distribution branch" % [ branch ]
          return
      warn "the $1 distribution branch is not available" % [ branch ]
    else:
      warn switch.output

when isMainModule:
  let logger = newCuteConsoleLogger()
  addHandler logger

  let app = extractFilename getAppFilename()
  info "$1 on $2 for Nim $3" % [ app, repo(), NimVersion ]

  if paramCount() == 0:
    refresh()
    info "specify a branch; eg. `git nim 1.2.2` or `git nim origin/1.0.7`:"
    info git("branch --all --sort=version:refname --verbose", {poStdErrToStdOut})
    info "or you can specify one of these tags; eg. `git nim latest`:"
    info git("tag --list -n2 --sort=version:refname", {poStdErrToStdOut})
  else:
    if switch paramStr(1):
      info nim ["--version"]
