/** Provides configurations to be used in queries related to regex injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.regexp.RegexInjection

/**
 * DEPRECATED: Use `RegexInjectionFlow` instead.
 *
 * A taint-tracking configuration for untrusted user input used to construct regular expressions.
 */
deprecated class RegexInjectionConfiguration extends TaintTracking::Configuration {
  RegexInjectionConfiguration() { this = "RegexInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof RegexInjectionSanitizer }
}

/**
 * A taint-tracking configuration for untrusted user input used to construct regular expressions.
 */
module RegexInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof RegexInjectionSanitizer }
}

module RegexInjectionFlow = TaintTracking::Global<RegexInjectionConfig>;
