import java
import semmle.code.java.dataflow.TaintTracking

query predicate literalCall(
  MethodCall call, Method target, string resultType, Expr qualifier, int argumentCount
) {
  target = call.getMethod() and
  target.hasName("of") and
  call.getEnclosingCallable().fromSource() and
  resultType = call.getType().toString() and
  qualifier = call.getQualifier() and
  argumentCount = call.getNumArgument()
}

query predicate literalArguments(MethodCall call, int index, Expr argument) {
  call.getMethod().hasName("of") and
  argument = call.getArgument(index)
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("source") }

  predicate isSink(DataFlow::Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
