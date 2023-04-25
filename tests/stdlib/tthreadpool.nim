discard """
  matrix: "--mm:arc; --mm:refc"
  disabled: "freebsd"
  output: "42"
"""
import std/assertions
from std/threadpool import spawn, `^`, sync
block: # bug #12005
  proc doworkok(i: int) {.thread.} = echo i
  spawn(doworkok(42))
  sync() # this works when returning void!

  proc doworkbad(i: int): int {.thread.} = i
  doAssert ^spawn(doworkbad(42)) == 42 # bug was here
