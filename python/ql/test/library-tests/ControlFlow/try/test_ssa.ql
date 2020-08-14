import python

from SsaVariable var, ControlFlowNode use
where use = var.getAUse()
select var.getLocation().getFile().getShortName(), var.toString(), var.getLocation().getStartLine(),
  use.toString(), use.getLocation().getStartLine()
