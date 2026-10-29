import python

from SsaVariable var, SsaVariable arg
where arg = var.getAPhiInput()
select var.getLocation().getFile().getShortName(), var.toString(), var.getLocation().getStartLine(),
  arg, arg.getLocation().getStartLine()
