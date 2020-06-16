import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

class Conf extends Configuration {
  Conf() { this = "test types" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("source") }

  override predicate isSink(Node n) {
    exists(MethodAccess sink |
      sink.getAnArgument() = n.asExpr() and sink.getMethod().hasName("sink")
    )
  }

  override predicate isAdditionalFlowStep(Node n1, Node n2) {
    exists(MethodAccess ma |
      ma.getMethod().hasName("customStep") and
      ma.getAnArgument() = n1.asExpr() and
      ma = n2.asExpr()
    )
  }
}

from Node src, Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink, sink.getEnclosingCallable()
