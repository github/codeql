import python

from ControlFlowNode use, SsaVariable def
where def.getAUse() = use
select use.getLocation().getFile().getShortName(), use.toString(), use.getLocation().getStartLine(),
  def.toString(), def.getLocation().getStartLine()
