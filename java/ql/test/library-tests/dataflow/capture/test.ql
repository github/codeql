import java
import semmle.code.java.dataflow.DataFlow

StringLiteral src() {
  result.getCompilationUnit().fromSource() and
  result.getFile().toString() = "A"
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() = src() }

  predicate isSink(DataFlow::Node n) { any() }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node src, DataFlow::Node sink
where Flow::flow(src, sink)
select src, sink
