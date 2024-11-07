/** Provides configurations to be used in queries related to regex injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.regexp.RegexInjection

/**
 * A taint-tracking configuration for untrusted user input used to construct regular expressions.
 */
module RegexInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof RegexInjectionSanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking flow for untrusted user input used to construct regular expressions.
 */
module RegexInjectionFlow = TaintTracking::Global<RegexInjectionConfig>;
