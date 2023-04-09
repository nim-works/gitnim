discard """
  matrix: "--mm:refc -d:release; --mm:orc -d:release"
"""

{.passC: "-fsanitize=undefined -fsanitize-undefined-trap-on-error -Wall -Wextra -pedantic -flto".}
{.passL: "-fsanitize=undefined -fsanitize-undefined-trap-on-error -flto".}

# bug #20972
type ForkedEpochInfo = object
  case kind: bool
  of true, false: discard
var info = ForkedEpochInfo(kind: true)
doAssert info.kind
info.kind = false
doAssert not info.kind
