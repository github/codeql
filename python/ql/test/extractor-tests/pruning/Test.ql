import python

from Module m
select m.getName(), m.getFile().getAbsolutePath(),
  count(ControlFlowNode n | n.getScope().getEnclosingModule() = m)
