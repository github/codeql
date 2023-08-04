/** Provides a taint-tracking configuration to reason about externally controlled format string vulnerabilities. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.StringFormat

/**
 * A taint-tracking configuration for externally controlled format string vulnerabilities.
 */
module ExternallyControlledFormatStringConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(StringFormat formatCall).getFormatArgument()
  }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof NumericType or node.getType() instanceof BooleanType
  }
}

/**
 * Taint-tracking flow for externally controlled format string vulnerabilities.
 */
module ExternallyControlledFormatStringFlow =
  TaintTracking::Global<ExternallyControlledFormatStringConfig>;
