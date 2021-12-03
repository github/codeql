import python

from SsaVariable var, SsaVariable def
where def = var.getAnUltimateDefinition()
select var.getLocation().getFile().getShortName(), var.toString(), var.getLocation().getStartLine(),
  def, def.getLocation().getStartLine()
