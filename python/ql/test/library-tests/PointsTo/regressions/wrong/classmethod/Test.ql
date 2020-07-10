import python

from NameNode name, CallNode call, string debug
where
  call.getAnArg() = name and
  call.getFunction().(NameNode).getId() = "check" and
  if exists(name.pointsTo())
  then debug = name.pointsTo().toString()
  else debug = "<MISSING pointsTo()>"
select name, debug
