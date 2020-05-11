import python

from SsaVariable var, SsaVariable arg, BasicBlock pred
where pred = var.getPredecessorBlockForPhiArgument(arg)
select var.getLocation().getFile().getShortName(), var.toString(), var.getLocation().getStartLine(),
  arg, arg.getLocation().getStartLine(), pred.getLastNode().getLocation().getStartLine()
