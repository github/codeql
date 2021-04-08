import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

class Conf extends Configuration {
  Conf() { this = "qqconf" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("source") }

  override predicate isSink(Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("sink") }
}

from Node src, Node sink, Conf c
where c.hasFlow(src, sink)
select src, sink
