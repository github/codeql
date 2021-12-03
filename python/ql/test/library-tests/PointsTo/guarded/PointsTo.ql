import python

from ControlFlowNode f, Object o, ControlFlowNode x
where
  f.refersTo(o, x) and
  exists(CallNode call | call.getFunction().getNode().(Name).getId() = "use" and call.getArg(0) = f)
select f.getLocation().getFile().getShortName(), f.getLocation().getStartLine(), f.toString(),
  o.toString(), x.getLocation().getStartLine()
