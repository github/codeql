import python

from ControlFlowNode arg, CallNode call, string debug
where
  call.getAnArg() = arg and
  call.getFunction().(NameNode).getId() = "check" and
  if exists(arg.pointsTo())
  then debug = arg.pointsTo().toString()
  else debug = "<MISSING pointsTo()>"
select arg, debug
