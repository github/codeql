import java
import semmle.code.java.dataflow.DataFlow

module ThisFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(DataFlow::PostUpdateNode cie | cie.asExpr() instanceof ClassInstanceExpr |
      cie.getPreUpdateNode() = src or cie = src
    )
  }

  predicate isSink(DataFlow::Node sink) { any() }
}

module ThisFlow = DataFlow::Global<ThisFlowConfig>;

from DataFlow::Node n
where ThisFlow::flowTo(n)
select n
