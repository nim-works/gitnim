discard """
action: compile
"""

import tables

{.experimental: "strictNotNil".}

type
  Nilable* = ref object
    a*: int
    field*: Nilable
    
  NonNilable* = Nilable not nil

  Nilable2* = nil NonNilable


# proc `[]`(a: Nilable, b: int): Nilable =
#   nil


# Nilable tests



# test deref
proc testDeref(a: Nilable) =
  echo a.a > 0 #[tt.Warning
       ^ can't deref a, it might be nil
  ]#



# # # test if else
proc testIfElse(a: Nilable) =
  if a.isNil:
    echo a.a #[tt.Warning
         ^ can't deref a, it is nil
    ]#
  else:
    echo a.a # ok

proc testIfNoElse(a: Nilable) =
  if a.isNil:
    echo a.a #[tt.Warning
         ^ can't deref a, it is nil
         ]#
  echo a.a #[tt.Warning
       ^ can't deref a, it might be nil
   ]#

proc testIfReturn(a: Nilable) =
  if not a.isNil:
    return
  echo a.a #[tt.Warning
       ^ can't deref a, it is nil
  ]#

proc testIfBreak(a: seq[Nilable]) =
  for b in a:
    if not b.isNil:
      break
    echo b.a #[tt.Warning
         ^ can't deref b, it is nil
    ]#

proc testIfContinue(a: seq[Nilable]) =
  for b in a:
    if not b.isNil:
      continue
    echo b.a #[tt.Warning
         ^ can't deref b, it is nil
    ]#

proc testIfRaise(a: Nilable) =
  if not a.isNil:
    raise newException(ValueError, "")
  echo a.a #[tt.Warning
       ^ can't deref a, it is nil
  ]#

proc testIfElif(a: Nilable) =
  var c = 0
  if c == 0:
    echo a.a #[tt.Warning
         ^ can't deref a, it might be nil
      ]#
  elif c == 1:
    echo a.a #[tt.Warning
         ^ can't deref a, it might be nil
      ]#
  elif not a.isNil:
    echo a.a # ok
  elif c == 2:
    echo 0
  else:
    echo a.a #[tt.Warning
         ^ can't deref a, it is nil
    ]#

proc testAssignUnify(a: Nilable, b: int) =
  var a2 = a
  if b == 0:
    a2 = Nilable()
  echo a2.a #[tt.Warning
       ^ can't deref a2, it might be nil
  ]#


# # test assign in branch and unifiying that with the main block after end of branch
proc testAssignUnifyNil(a: Nilable, b: int) =
  var a2 = a
  if b == 0:
    a2 = nil
  echo a2.a #[tt.Warning
       ^ can't deref a2, it might be nil
  ]#

# test loop
proc testForLoop(a: Nilable) =
  var b = Nilable()
  for i in 0 .. 5:
    echo b.a #[tt.Warning
         ^ can't deref b, it might be nil
    ]#
    if i == 2:
      b = a
  echo b.a #[tt.Warning
       ^ can't deref b, it might be nil
  ]#



# # TODO implement this after discussion
# # proc testResultCompoundNonNilableElement(a: Nilable): (NonNilable, NonNilable) = #[t t.Warning
# #      ^ result might be not initialized, so it or an element might be nil
# # ]#
# #   if not a.isNil:
# #     result[0] = a #[t t.Warning
# #                 ^ can't assign nilable to non nilable: it might be nil
# #     #]

# # proc testNonNilDeref(a: NonNilable) =
# #   echo a.a # ok



# # # not only calls: we can use partitions for dependencies for field aliases
# # # so we can detect on change what does this affect or was this mutated between us and the original field

# # proc testRootAliasField(a: Nilable) =
# #   var aliasA = a
# #   if not a.isNil and not a.field.isNil:
# #     aliasA.field = nil
# #     # a.field = nil
# #     # aliasA = nil 
# #     echo a.field.a # [tt.Warning
# #          ^ can't deref a.field, it might be nil
# #     ]#


proc testAliasChanging(a: Nilable) =
  var b = a
  var aliasA = b
  b = Nilable()
  if not b.isNil:
    echo aliasA.a #[tt.Warning
         ^ can't deref aliasA, it might be nil
    ]#

# # TODO
# # proc testAliasUnion(a: Nilable) =
# #   var a2 = a
# #   var b = a2
# #   if a.isNil:
# #     b = Nilable()
# #     a2 = nil
# #   else:
# #     a2 = Nilable()
# #     b = a2
# #   if not b.isNil:
# #     echo a2.a #[ tt.Warning
# #          ^ can't deref a2, it might be nil
# #     ]#

# # TODO after alias support
# #proc callVar(a: var Nilable) =
# #  a.field = nil


# # TODO ptr support
# # proc testPtrAlias(a: Nilable) =
# #   # pointer to a: hm.
# #   # alias to a?
# #   var ptrA = a.addr # {0, 1} 
# #   if not a.isNil: # {0, 1}
# #     ptrA[] = nil # {0, 1} 0: MaybeNil 1: MaybeNil
# #     echo a.a #[ tt.Warning
# #          ^ can't deref a, it might be nil
# #     ]#

# # TODO field stuff
# # currently it just doesnt support dot, so accidentally it shows a warning but because that
# # not alias i think
# # proc testFieldAlias(a: Nilable) =
# #   var b = a # {0, 1} {2} 
# #   if not a.isNil and not a.field.isNil: # {0, 1} {2}
# #     callVar(b) # {0, 1} {2} 0: Safe 1: Safe
# #     echo a.field.a #[ tt.Warning
# #           ^ can't deref a.field, it might be nil
# #     ]#
# #
# # proc testUniqueHashTree(a: Nilable): Nilable =
# #   # TODO what would be a clash
# #   var field = 0
# #   if not a.isNil and not a.field.isNil:
# #     # echo a.field.a
# #     echo a[field].a
# #   result = Nilable()
  
# # proc testSeparateShadowingResult(a: Nilable): Nilable =
# #   result = Nilable()
# #   if not a.isNil:
# #     var result: Nilable = nil
# #   echo result.a


proc testCStringDeref(a: cstring) =
  echo a[0] #[tt.Warning
       ^ can't deref a, it might be nil
  ]#


proc testNilablePtr(a: ptr int) =
  if not a.isNil:
    echo a[] # ok
  echo a[] #[tt.Warning
       ^ can't deref a, it might be nil
  ]#

# # proc testNonNilPtr(a: ptr int not nil) =
# #   echo a[] # ok

proc raiseCall: NonNilable = #[tt.Warning
^ return value is nil
]#
  raise newException(ValueError, "raise for test") 

# proc testTryCatch(a: Nilable) =
#   var other = a
#   try:
#     other = raiseCall()
#   except:
#     discard
#   echo other.a #[ tt.Warning
#             ^ can't deref other, it might be nil
#   ]#

# # proc testTryCatchDetectNoRaise(a: Nilable) =
# #   var other = Nilable()
# #   try:
# #     other = nil
# #     other = a
# #     other = Nilable()
# #   except:
# #     other = nil
# #   echo other.a # ok

# # proc testTryCatchDetectFinally =
# #   var other = Nilable()
# #   try:
# #     other = nil
# #     other = Nilable()
# #   except:
# #     other = Nilable()
# #   finally:
# #     other = nil
# #   echo other.a # can't deref other: it is nil

# # proc testTryCatchDetectNilableWithRaise(b: bool) =
# #   var other = Nilable()
# #   try:
# #     if b:
# #       other = nil
# #     else:
# #       other = Nilable()
# #       var other2 = raiseCall()
# #   except:
# #     echo other.a # ok

# #   echo other.a # can't deref a: it might be nil

# # proc testRaise(a: Nilable) =
# #   if a.isNil:
# #     raise newException(ValueError, "a == nil")
# #   echo a.a # ok


# # proc testBlockScope(a: Nilable) =
# #   var other = a
# #   block:
# #     var other = Nilable()
# #     echo other.a # ok
# #   echo other.a # can't deref other: it might be nil

# # ok we can't really get the nil value from here, so should be ok
# # proc testDirectRaiseCall: NonNilable =
# #   var a = raiseCall()
# #   result = NonNilable()

# # proc testStmtList =
# #   var a = Nilable()
# #   block:
# #     a = nil
# #     a = Nilable()
# #   echo a.a # ok

proc callChange(a: Nilable) =
  if not a.isNil:
    a.field = nil

proc testCallChangeField =
  var a = Nilable()
  a.field = Nilable()
  callChange(a)
  echo a.field.a #[ tt.Warning
        ^ can't deref a.field, it might be nil
       ]#

proc testReassignVarWithField =
  var a = Nilable()
  a.field = Nilable()
  echo a.field.a # ok
  a = Nilable()
  echo a.field.a #[ tt.Warning
        ^ can't deref a.field, it might be nil
        ]#


proc testItemDeref(a: var seq[Nilable]) =
  echo a[0].a #[tt.Warning
        ^ can't deref a[0], it might be nil
       ]#
  a[0] = Nilable() # good: now .. if we dont track, how do we know 
  echo a[0].a # ok
  echo a[1].a #[tt.Warning
        ^ can't deref a[1], it might be nil
  ]#
  var b = 1
  if a[b].isNil:
    echo a[1].a #[tt.Warning
          ^ can't deref a[1], it might be nil
    ]#
    var c = 0
    echo a[c].a #[tt.Warning
          ^ can't deref a[c], it might be nil
    ]#

  # known false positive
  if not a[b].isNil:
    echo a[b].a #[tt.Warning
          ^ can't deref a[b], it might be nil
    ]#

  const c = 0
  if a[c].isNil:
    echo a[0].a #[tt.Warning
          ^ can't deref a[0], it is nil
    ]#
  a[c] = Nilable()
  echo a[0].a # ok



# # # proc test10(a: Nilable) =
# # #   if not a.isNil and not a.b.isNil:
# # #     c_memset(globalA.addr, 0, globalA.sizeOf.csize_t)
# # #     globalA = nil
# # #     echo a.a # can't deref a: it might be nil

