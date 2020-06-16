import python

from SsaVariable var
select var.getLocation().getFile().getShortName(), var, var.getLocation().getStartLine()
