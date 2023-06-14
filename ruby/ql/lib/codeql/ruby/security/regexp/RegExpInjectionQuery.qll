/**
 * Provides a taint-tracking configuration for detecting regexp injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `RegExpInjectionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import RegExpInjectionCustomizations
import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting regexp injection vulnerabilities.
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RegExpInjection::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof RegExpInjection::Sink }

  additional deprecated predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof RegExpInjection::SanitizerGuard
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof RegExpInjection::Sanitizer }
}
