discard """
  errormsg: '''type mismatch: got <proc (s: string)>'''
  line: 11
"""
#5620
var res = ""

proc takeCallback(foo: (proc(s: string) {.gcsafe.})) =
  foo "string"

takeCallback(proc (s: string) =
  res &= s & "abc")
