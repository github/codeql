private import python
private import semmle.python.dataflow.new.internal.DataFlowPrivate
private import semmle.python.dataflow.new.internal.DataFlowPublic

from DataFlowCall call, DataFlowCallable callable, ArgumentNode arg, ArgumentPosition apos
where
  callable = call.getCallable() and
  arg = call.getArgument(apos)
select call, callable, arg, apos
