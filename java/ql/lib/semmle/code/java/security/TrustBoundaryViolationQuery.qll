/** Provides classes and predicates to reason about trust boundary violations */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources

/**
 * A source of data that crosses a trust boundary.
 */
abstract class TrustBoundaryViolationSource extends DataFlow::Node { }

/**
 * A node representing a servlet request.
 */
private class ServletRequestSource extends TrustBoundaryViolationSource {
  ServletRequestSource() { this.asExpr().getType() instanceof HttpServletRequest }
}

/**
 * A sink for data that crosses a trust boundary.
 */
class TrustBoundaryViolationSink extends DataFlow::Node {
  TrustBoundaryViolationSink() { sinkNode(this, "trust-boundary") }
}

/**
 * Taint tracking for data that crosses a trust boundary.
 */
module TrustBoundaryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof TrustBoundaryViolationSource }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    n2.asExpr().(MethodAccess).getQualifier() = n1.asExpr()
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof TrustBoundaryViolationSink }
}

/**
 * Taint-tracking flow for values which cross a trust boundary.
 */
module TrustBoundaryFlow = TaintTracking::Global<TrustBoundaryConfig>;
