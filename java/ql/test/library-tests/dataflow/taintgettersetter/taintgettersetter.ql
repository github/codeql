import java
import semmle.code.java.dataflow.DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("taint") }

  predicate isSink(DataFlow::Node n) {
    exists(MethodCall sink | sink.getAnArgument() = n.asExpr() and sink.getMethod().hasName("sink"))
  }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(AddExpr add |
      add.getType() instanceof TypeString and add.getAnOperand() = n1.asExpr() and n2.asExpr() = add
    )
  }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node src, DataFlow::Node sink
where Flow::flow(src, sink)
select src, sink
