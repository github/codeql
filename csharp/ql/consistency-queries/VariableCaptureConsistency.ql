import csharp
import semmle.code.csharp.dataflow.internal.DataFlowPrivate::VariableCapture::Flow::ConsistencyChecks
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate::VariableCapture::Flow::ConsistencyChecks as ConsistencyChecks

query predicate consistencyOverview(string msg, int n) { none() }

query predicate uniqueCallableLocation(Callable c, string msg) {
  ConsistencyChecks::uniqueCallableLocation(c, msg) and
  count(c.getBody()) = 1
}
