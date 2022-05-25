import python
private import semmle.python.dataflow.new.internal.PrintNode

from CallNode call
where
  exists(call.getLocation().getFile().getRelativePath()) and
  not exists(Value value | call = value.getACall()) and
  // somehow print is not resolved, but that is not the focus right now
  not call.getFunction().(NameNode).getId() = "print"
select call.getLocation(), prettyExpr(call.getNode())
