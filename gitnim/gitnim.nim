import std/strformat
import std/macros except `error`
import std/os
import std/strutils
import std/osproc
import std/logging

import cutelog

const
  defaultProcess = {poStdErrToStdOut, poParentStreams}
  envURL {.strdefine.}: string = "GITNIM_URL"
  URL {.strdefine.}: string = getEnv(envURL)

type
  RunOutput = object
    arguments: seq[string]
    output: string
    ok: bool

macro repo(): untyped =
  let getEnv = bindSym"getEnv"
  echo $typeof(getEnv)
  result = getEnv.newCall("GITNIM_URL".newLit, "goats".newLit)

template crash(why: string) =
  error why
  quit 1

proc run(exe: string; args: openArray[string];
         options = defaultProcess): RunOutput =
  ## run a program with arguments
  var
    command = findExe(exe)
    arguments: seq[string]
    opts = options
  for a in args: arguments.add a
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
      when false:
        # the user wants to capture output
        command &= " " & quoteShellCommand(arguments)
        when defined(debug):
          debug command
        let
          (output, code) = execCmdEx(command, opts)
        result = RunOutput(output: output, ok: code == 0)

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

  info "gitnim on ", repo()
  git "fetch --all".split
  info git("branch --list".split, {poStdErrToStdOut})

  if paramCount() > 0:
    git ["checkout", paramStr(1)]
    info nim ["--version"]
