import java
import semmle.code.java.dataflow.DataFlow

class Conf extends DataFlow::Configuration {
  Conf() { this = "qqconf" }

  override predicate isSource(DataFlow::Node n) { n.asExpr() instanceof NullLiteral }

  override predicate isSink(DataFlow::Node n) { any() }
}

from Conf conf, DataFlow::Node src, DataFlow::Node sink
where conf.hasFlow(src, sink)
select src, sink
