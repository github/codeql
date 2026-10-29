import python
private import LegacyPointsTo

from ControlFlowNodeWithPointsTo use, string outcome
where
  exists(CallNode call | call.getFunction().(NameNode).getId() = "InTyping" and use = call) and
  (
    if exists(use.pointsTo())
    then outcome = "resolved: " + use.pointsTo().toString()
    else outcome = "no points-to info"
  )
select use, outcome