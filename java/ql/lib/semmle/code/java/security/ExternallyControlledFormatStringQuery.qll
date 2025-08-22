/** Provides a taint-tracking configuration to reason about externally controlled format string vulnerabilities. */

import java
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.StringFormat

/**
 * A string format sink node.
 */
private class StringFormatSink extends ApiSinkNode {
  StringFormatSink() { this.asExpr() = any(StringFormat formatCall).getFormatArgument() }
}

/**
 * A taint-tracking configuration for externally controlled format string vulnerabilities.
 */
module ExternallyControlledFormatStringConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof StringFormatSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof NumericType or node.getType() instanceof BooleanType
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking flow for externally controlled format string vulnerabilities.
 */
module ExternallyControlledFormatStringFlow =
  TaintTracking::Global<ExternallyControlledFormatStringConfig>;
