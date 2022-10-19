discard """
outputsub: ""
"""

# Test Posix interface

when not defined(windows):

  import posix
  import std/syncio

  var
    u: Utsname

  discard uname(u)

  writeLine(stdout, u.sysname)
  writeLine(stdout, u.nodename)
  writeLine(stdout, u.release)
  writeLine(stdout, u.machine)
