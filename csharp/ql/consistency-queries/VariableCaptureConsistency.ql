import csharp
import semmle.code.csharp.dataflow.internal.DataFlowPrivate::VariableCapture::Flow::ConsistencyChecks
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate::VariableCapture::Flow::ConsistencyChecks as ConsistencyChecks
private import semmle.code.csharp.controlflow.BasicBlocks

query predicate uniqueEnclosingCallable(BasicBlock bb, string msg) {
  ConsistencyChecks::uniqueEnclosingCallable(bb, msg)
}

query predicate consistencyOverview(string msg, int n) { none() }

query predicate uniqueCallableLocation(Callable c, string msg) {
  ConsistencyChecks::uniqueCallableLocation(c, msg) and
  count(c.getBody()) = 1
}
