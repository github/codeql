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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RegExpInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RegExpInjection::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegExpInjection::Sink }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof RegExpInjection::SanitizerGuard
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof RegExpInjection::Sanitizer }
}
