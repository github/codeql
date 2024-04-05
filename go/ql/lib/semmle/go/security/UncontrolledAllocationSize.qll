/**
 * Provides a taint-tracking configuration for reasoning about uncontrolled allocation size issues.
 */

import go

/**
 * Provides a taint-tracking flow for reasoning about uncontrolled allocation size issues.
 */
module UncontrolledAllocationSize {
  private import UncontrolledAllocationSizeCustomizations::UncontrolledAllocationSize

  /**
   * Module for defining predicates and tracking taint flow related to uncontrolled allocation size issues.
   */
  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      exists(Function f, DataFlow::CallNode cn | cn = f.getACall() |
        f.hasQualifiedName("strconv", ["Atoi", "ParseInt", "ParseUint", "ParseFloat"]) and
        node1 = cn.getArgument(0) and
        node2 = cn.getResult(0)
      )
    }
  }

  /** Tracks taint flow for reasoning about uncontrolled allocation size issues. */
  module Flow = TaintTracking::Global<Config>;
}
