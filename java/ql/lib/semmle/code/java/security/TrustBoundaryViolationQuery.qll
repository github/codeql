/** Provides classes and predicates to reason about trust boundary violations */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.frameworks.Servlets

class TrustBoundaryViolationSource extends DataFlow::Node {
  TrustBoundaryViolationSource() { this.asExpr().getType() instanceof HttpServletRequest }
}

class TrustBoundaryViolationSink extends DataFlow::Node {
  TrustBoundaryViolationSink() { sinkNode(this, "trust-boundary") }
}

module TrustBoundaryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof TrustBoundaryViolationSource }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    n2.asExpr().(MethodAccess).getQualifier() = n1.asExpr()
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof TrustBoundaryViolationSink }
}

module TrustBoundaryFlow = TaintTracking::Global<TrustBoundaryConfig>;
