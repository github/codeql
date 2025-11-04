import python
private import LegacyPointsTo

from StringObject s, ControlFlowNodeWithPointsTo f
where f.refersTo(s)
select f.getLocation().toString(), s.getText()
