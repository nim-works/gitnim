version = "1.0.0"
author = "disruptek"
description = "choosenim for choosey nimions"
license = "MIT"

namedBin = {"gitnim": "git-nim"}.toTable

when not defined(release):
  requires "https://github.com/disruptek/balls >= 2.0.0 & < 3.0.0"

task test, "run unit testes":
  when defined(windows):
    exec "balls.cmd --define:debug"
  else:
    exec "balls --define:debug"

task demo, "generate examples":
  exec """demo docs/gitnim.svg "git nim""""
  exec """demo docs/gitnim143.svg "git nim 1.4.3""""
  exec """demo docs/gitnimdevel.svg "git nim devel""""
  exec """demo docs/gitnimstable.svg "git nim stable""""
