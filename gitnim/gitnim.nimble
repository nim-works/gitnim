version = "1.0.0"
author = "disruptek"
description = "choosenim for choosey nimions"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/testes >= 1.0.0 & < 2.0.0"

task test, "run unit testes":
  when defined(windows):
    exec "testes.cmd --define:gitnimDebug"
  else:
    exec "testes --define:gitnimDebug"
