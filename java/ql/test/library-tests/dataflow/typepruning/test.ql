import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("source") }

  predicate isSink(Node n) {
    exists(MethodAccess sink |
      sink.getAnArgument() = n.asExpr() and sink.getMethod().hasName("sink")
    )
  }

  predicate isAdditionalFlowStep(Node n1, Node n2) {
    exists(MethodAccess ma |
      ma.getMethod().hasName("customStep") and
      ma.getAnArgument() = n1.asExpr() and
      ma = n2.asExpr()
    )
  }
}

module Flow = DataFlow::Global<Config>;

from Node src, Node sink
where Flow::flow(src, sink)
select src, sink, sink.getEnclosingCallable()
