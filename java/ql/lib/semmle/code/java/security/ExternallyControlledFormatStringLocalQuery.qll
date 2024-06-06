/** Provides a taint-tracking configuration to reason about externally-controlled format strings from local sources. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.StringFormat

/** A taint-tracking configuration to reason about externally-controlled format strings from local sources. */
deprecated module ExternallyControlledFormatStringLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(StringFormat formatCall).getFormatArgument()
  }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof NumericType or node.getType() instanceof BooleanType
  }
}

/**
 * DEPRECATED: Use `ExternallyControlledFormatStringFlow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for externally-controlled format strings from local sources.
 */
deprecated module ExternallyControlledFormatStringLocalFlow =
  TaintTracking::Global<ExternallyControlledFormatStringLocalConfig>;
