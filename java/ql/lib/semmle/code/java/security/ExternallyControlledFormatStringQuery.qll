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

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 22 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-134/ExternallyControlledFormatString.ql@24:8:24:37)
  }
}

/**
 * Taint-tracking flow for externally controlled format string vulnerabilities.
 */
module ExternallyControlledFormatStringFlow =
  TaintTracking::Global<ExternallyControlledFormatStringConfig>;
