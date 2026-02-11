/**
 * Provides a taint-tracking configuration for detecting regexp injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `RegExpInjectionFlow` is needed, otherwise
 * `RegExpInjectionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import RegExpInjectionCustomizations
import codeql.ruby.dataflow.BarrierGuards

private module RegExpInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RegExpInjection::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof RegExpInjection::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof RegExpInjection::Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting regexp injection vulnerabilities.
 */
module RegExpInjectionFlow = TaintTracking::Global<RegExpInjectionConfig>;
