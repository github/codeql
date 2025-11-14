import python
private import LegacyPointsTo

from NameNode name, CallNode call, string debug
where
  call.getAnArg() = name and
  call.getFunction().(NameNode).getId() = "check" and
  if exists(name.(ControlFlowNodeWithPointsTo).pointsTo())
  then debug = name.(ControlFlowNodeWithPointsTo).pointsTo().toString()
  else debug = "<MISSING pointsTo()>"
select name, debug
