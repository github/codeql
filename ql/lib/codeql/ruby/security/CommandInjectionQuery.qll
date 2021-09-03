/**
 * Provides a taint tracking configuration for reasoning about
 * command-injection vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjection::Configuration` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

import ruby
import codeql.ruby.TaintTracking
import CommandInjectionCustomizations::CommandInjection
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CommandInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare or
    guard instanceof StringConstArrayInclusionCall
  }
}
