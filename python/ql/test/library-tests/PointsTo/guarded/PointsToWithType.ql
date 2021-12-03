import python

from ControlFlowNode f, Object o, ClassObject c, ControlFlowNode x
where
  f.refersTo(o, c, x) and
  exists(CallNode call | call.getFunction().getNode().(Name).getId() = "use" and call.getArg(0) = f)
select f.getLocation().getFile().getShortName(), f.getLocation().getStartLine(), f.toString(),
  o.toString(), c.toString(), x.getLocation().getStartLine()
