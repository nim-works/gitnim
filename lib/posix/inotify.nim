#
#
#            Nim's Runtime Library
#        (c) Copyright 2012 Dominik Picheta
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

when defined(nimPreviewSlimSystem):
  import std/syncio

# Get the platform-dependent flags.
# Structure describing an inotify event.
type
  InotifyEvent* {.pure, final, importc: "struct inotify_event",
                  header: "<sys/inotify.h>".} = object ## An Inotify event.
    wd* {.importc: "wd".}: FileHandle                  ## Watch descriptor.
    mask* {.importc: "mask".}: uint32                  ## Watch mask.
    cookie* {.importc: "cookie".}: uint32              ## Cookie to synchronize two events.
    len* {.importc: "len".}: uint32                    ## Length (including NULs) of name.
    name* {.importc: "name".}: char                    ## Name.

# Supported events suitable for MASK parameter of INOTIFY_ADD_WATCH.
const
  IN_ACCESS* = 0x00000001                          ## File was accessed.
  IN_MODIFY* = 0x00000002                          ## File was modified.
  IN_ATTRIB* = 0x00000004                          ## Metadata changed.
  IN_CLOSE_WRITE* = 0x00000008                     ## Writtable file was closed.
  IN_CLOSE_NOWRITE* = 0x00000010                   ## Unwrittable file closed.
  IN_CLOSE* = (IN_CLOSE_WRITE or IN_CLOSE_NOWRITE) ## Close.
  IN_OPEN* = 0x00000020                            ## File was opened.
  IN_MOVED_FROM* = 0x00000040                      ## File was moved from X.
  IN_MOVED_TO* = 0x00000080                        ## File was moved to Y.
  IN_MOVE* = (IN_MOVED_FROM or IN_MOVED_TO)        ## Moves.
  IN_CREATE* = 0x00000100                          ## Subfile was created.
  IN_DELETE* = 0x00000200                          ## Subfile was deleted.
  IN_DELETE_SELF* = 0x00000400                     ## Self was deleted.
  IN_MOVE_SELF* = 0x00000800                       ## Self was moved.

# Events sent by the kernel.
const
  IN_UNMOUNT* = 0x00002000    ## Backing fs was unmounted.
  IN_Q_OVERFLOW* = 0x00004000 ## Event queued overflowed.
  IN_IGNORED* = 0x00008000    ## File was ignored.

# Special flags.
const
  IN_ONLYDIR* = 0x01000000     ## Only watch the path if it is a directory.
  IN_DONT_FOLLOW* = 0x02000000 ## Do not follow a sym link.
  IN_EXCL_UNLINK* = 0x04000000 ## Exclude events on unlinked objects.
  IN_MASK_ADD* = 0x20000000    ## Add to the mask of an already existing watch.
  IN_ISDIR* = 0x40000000       ## Event occurred against dir.
  IN_ONESHOT* = 0x80000000     ## Only send event once.

# All events which a program can wait on.
const
  IN_ALL_EVENTS* = (IN_ACCESS or IN_MODIFY or IN_ATTRIB or IN_CLOSE_WRITE or
      IN_CLOSE_NOWRITE or IN_OPEN or IN_MOVED_FROM or IN_MOVED_TO or
      IN_CREATE or IN_DELETE or IN_DELETE_SELF or IN_MOVE_SELF)


proc inotify_init*(): FileHandle {.cdecl, importc: "inotify_init",
    header: "<sys/inotify.h>".}
  ## Create and initialize inotify instance.

proc inotify_init1*(flags: cint): FileHandle {.cdecl, importc: "inotify_init1",
    header: "<sys/inotify.h>".}
  ## Create and initialize inotify instance.

proc inotify_add_watch*(fd: cint; name: cstring; mask: uint32): cint {.cdecl,
    importc: "inotify_add_watch", header: "<sys/inotify.h>".}
  ## Add watch of object NAME to inotify instance FD. Notify about events specified by MASK.

proc inotify_rm_watch*(fd: cint; wd: cint): cint {.cdecl,
    importc: "inotify_rm_watch", header: "<sys/inotify.h>".}
  ## Remove the watch specified by WD from the inotify instance FD.

iterator inotify_events*(evs: pointer, n: int): ptr InotifyEvent =
  ## Abstract the packed buffer interface to yield event object pointers.
  ##   ```Nim
  ##   var evs = newSeq[byte](8192)        # Already did inotify_init+add_watch
  ##   while (let n = read(fd, evs[0].addr, 8192); n) > 0:     # read forever
  ##     for e in inotify_events(evs[0].addr, n): echo e[].len # echo name lens
  ##   ```
  var ev: ptr InotifyEvent = cast[ptr InotifyEvent](evs)
  var n = n
  while n > 0:
    yield ev
    let sz = InotifyEvent.sizeof + int(ev[].len)
    n -= sz
    ev = cast[ptr InotifyEvent](cast[uint](ev) + uint(sz))

runnableExamples:
  when defined(linux):
    let inoty: FileHandle = inotify_init()           ## Create 1 Inotify.
    doAssert inoty >= 0                              ## Check for errors (FileHandle is alias to cint).
    let watchdoge: cint = inotify_add_watch(inoty, ".", IN_ALL_EVENTS) ## Add directory to watchdog.
    doAssert watchdoge >= 0                          ## Check for errors.
    doAssert inotify_rm_watch(inoty, watchdoge) >= 0 ## Remove directory from the watchdog
