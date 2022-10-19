discard """
  output: '''ob2 @[]
ob @[]
ob3 @[]
3
ob2 @[]
ob @[]
ob3 @[]
'''
  matrix: "--mm:refc"
"""

# bug #4776

import tables

type
  Base* = ref object of RootObj
    someSeq: seq[int]
    baseData: array[40000, byte]
  Derived* = ref object of Base
    data: array[40000, byte]

type
  ThreadPool = ref object
    threads: seq[ptr Thread[ThreadArg]]
    channels: seq[ThreadArg]
  TableChannel = Channel[TableRef[string, Base]]
  ThreadArg = ptr TableChannel

var globalTable {.threadvar.}: TableRef[string, Base]
globalTable = newTable[string, Base]()
let d = new(Derived)
globalTable.add("ob", d)
globalTable.add("ob2", d)
globalTable.add("ob3", d)

proc testThread(channel: ptr TableChannel) {.thread.} =
  globalTable = channel[].recv()
  for k, v in pairs globaltable:
    echo k, " ", v.someSeq
  var myObj: Base
  deepCopy(myObj, globalTable["ob"])
  myObj.someSeq = newSeq[int](100)
  let table = channel[].recv() # same table
  echo table.len
  for k, v in mpairs table:
    echo k, " ", v.someSeq
  assert(table.contains("ob")) # fails!
  assert(table.contains("ob2")) # fails!
  assert(table.contains("ob3")) # fails!

var channel: TableChannel

proc newThreadPool(threadCount: int) = #: ThreadPool =
  #new(result)
  #result.threads = newSeq[ptr Thread[ThreadArg]](threadCount)
  #var channel = cast[ptr TableChannel](allocShared0(sizeof(TableChannel)))
  channel.open()
  channel.send(globalTable)
  channel.send(globalTable)
  #createThread(threadPtr[], testThread, addr channel)
  testThread(addr channel)
  #result.threads[i] = threadPtr

proc stop(p: ThreadPool) =
  for t in p.threads:
    joinThread(t[])
    dealloc(t)


newThreadPool(1)#.stop()
