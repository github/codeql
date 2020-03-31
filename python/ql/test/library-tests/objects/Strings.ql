import python

from StringObject s, ControlFlowNode f
where f.refersTo(s)
select f.getLocation().toString(), s.getText()
