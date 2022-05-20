import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

class Conf extends Configuration {
  Conf() { this = "qqconf" }

  override predicate isSource(Node n) { n.asExpr().(MethodAccess).getMethod().hasName("source") }

  override predicate isSink(Node n) { any() }
}

from Conf c, Node sink
where c.hasFlow(_, sink)
select sink
