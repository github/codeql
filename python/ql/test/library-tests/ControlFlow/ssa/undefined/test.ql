import python

from SsaVariable var
where var.maybeUndefined()
select var.getDefinition().getLocation().getStartLine(), var.toString()
