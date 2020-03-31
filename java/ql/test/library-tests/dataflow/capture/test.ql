import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

StringLiteral src() { result.getCompilationUnit().fromSource() }

class Conf extends Configuration {
  Conf() { this = "qq capture" }

  override predicate isSource(Node n) { n.asExpr() = src() }

  override predicate isSink(Node n) { any() }
}

from Node src, Node sink, Conf conf
where conf.hasFlow(src, sink)
select src, sink
