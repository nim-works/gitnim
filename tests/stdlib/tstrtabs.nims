import std/[strtabs, assertions]

static:
  let t = {"name": "John", "city": "Monaco"}.newStringTable
  doAssert "${name} lives in ${city}" % t == "John lives in Monaco"
