/**
 * Provides a taint-tracking configuration for detecting "Code injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `CodeInjectionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import CodeInjectionCustomizations::CodeInjection
import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting "Code injection" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CodeInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof Sanitizer or
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  deprecated override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
