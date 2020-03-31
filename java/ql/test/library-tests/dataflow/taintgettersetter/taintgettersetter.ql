import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

class Conf extends Configuration {
  Conf() { this = "taintgettersetter" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("taint") }

  override predicate isSink(Node n) {
    exists(MethodAccess sink |
      sink.getAnArgument() = n.asExpr() and sink.getMethod().hasName("sink")
    )
  }

  override predicate isAdditionalFlowStep(Node n1, Node n2) {
    exists(AddExpr add |
      add.getType() instanceof TypeString and add.getAnOperand() = n1.asExpr() and n2.asExpr() = add
    )
  }
}

from Node src, Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
