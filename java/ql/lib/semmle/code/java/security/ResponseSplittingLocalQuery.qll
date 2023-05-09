/** Provides a taint-tracking configuration to reason about response splitting vulnerabilities from local user input. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.ResponseSplitting

/**
 * A taint-tracking configuration to reason about response splitting vulnerabilities from local user input.
 */
module ResponseSplittingLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType
  }
}

/**
 * Taint-tracking flow for response splitting vulnerabilities from local user input.
 */
module ResponseSplittingLocalFlow = TaintTracking::Global<ResponseSplittingLocalConfig>;
