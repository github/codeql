/** Provides classes and predicates to reason about trust boundary violations */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.frameworks.Servlets

class TrustBoundaryViolationSource extends DataFlow::Node {
  TrustBoundaryViolationSource() {
    this instanceof RemoteFlowSource and this.asExpr().getType() instanceof HttpServletRequest
  }
}

class TrustBoundaryViolationSink extends DataFlow::Node {
  TrustBoundaryViolationSink() { sinkNode(this, "trust-boundary") }
}
