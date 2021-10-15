import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

class ThisFlowConfig extends Configuration {
  ThisFlowConfig() { this = "ThisFlowConfig" }

  override predicate isSource(Node src) {
    exists(PostUpdateNode cie | cie.asExpr() instanceof ClassInstanceExpr |
      cie.getPreUpdateNode() = src or cie = src
    )
  }

  override predicate isSink(Node sink) { any() }
}

from Node n, ThisFlowConfig conf
where conf.hasFlow(_, n)
select n
