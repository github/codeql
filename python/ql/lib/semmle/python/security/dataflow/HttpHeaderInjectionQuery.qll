/**
 * Provides a taint tracking configuration for reasoning about HTTP header injection.
 */

import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import HttpHeaderInjectionCustomizations

/**
 * A taint-tracking configuration for detecting HTTP Header injection vulnerabilities.
 */
private module HeaderInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof HttpHeaderInjection::Source }

  predicate isSink(DataFlow::Node node) { node instanceof HttpHeaderInjection::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof HttpHeaderInjection::Sanitizer }
}

/** Global taint-tracking for detecting "HTTP Header injection" vulnerabilities. */
module HeaderInjectionFlow = TaintTracking::Global<HeaderInjectionConfig>;
