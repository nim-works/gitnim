import std/strformat
import std/macros except `error`
import std/os
import std/strutils
import std/osproc
import std/logging

import cutelog

const
  defaultProcess = {poStdErrToStdOut, poParentStreams}
  envURL: string = "GITNIM_URL"
  embURL: string = staticExec"git remote get-url origin"
  URL {.strdefine.}: string = getEnv(envURL, embURL)

static:
  hint "gitnim uses following url by default:"
  hint URL
  hint "via setting the $GITNIM_URL, or"
  hint "via passing --define:URL=\"...\""

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
      result = RunOutput(output: &"unable to find {exe} in path")
      warn result.output
      break ran

    if poParentStreams in opts or poInteractive in opts:
      # sorry; i just find this easier to read than union()
      opts.incl poInteractive
      opts.incl poParentStreams
      # the user wants interactivity
      when defined(debug):
        debug command, arguments.join(" ")
      let
        process = startProcess(command, $getAppDir(),
                               args = arguments, options = opts)
      result = RunOutput(ok: process.waitForExit == 0)
    else:
      let
        output = execProcess(command, $getAppDir(),
                             args = arguments, options = opts)
      result = RunOutput(ok: true, output: output)

    # for utility, also return the arguments we used
    result.arguments = arguments

    # a failure is worth noticing
    if not result.ok:
      notice exe & " " & arguments.join(" ")
    when defined(debug):
      debug "done running"

proc git(args: openArray[string]; options = defaultProcess): string
  {.discardable.} =
  run("git", args, options = options).output

proc nim(args: openArray[string]; options = defaultProcess): string =
  run("nim", args, options = options).output

when isMainModule:
  let
    logger = newCuteConsoleLogger()
  addHandler logger

  let
    app = extractFilename getAppFilename()
  info app & " on " & repo() & " for Nim " & NimVersion
  discard git("fetch --all".split, {poStdErrToStdOut})

  if paramCount() == 0:
    info "specify a branch; eg. `git nim 1.2.2` or `git nim origin/1.0.7`:"
    info git("branch --all --sort=version:refname --verbose --color".split, {poStdErrToStdOut})
    info "or you can specify one of these tags; eg. `git nim latest`:"
    info git("tag --list -n2 --sort=version:refname --color".split, {poStdErrToStdOut})
  else:
    git ["checkout", paramStr(1)]
    info nim ["--version"]
