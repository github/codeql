import java
import semmle.code.java.dataflow.TaintTracking

query predicate selectedProperty(
  LocalVariableDeclExpr variable, MethodCall initializer, Method getter
) {
  variable.getVariable().hasName("currency") and
  initializer = variable.getInit() and
  getter = initializer.getMethod()
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("source") }

  predicate isSink(DataFlow::Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
