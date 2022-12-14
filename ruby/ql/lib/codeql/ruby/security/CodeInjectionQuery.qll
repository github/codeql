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

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    state = source.(Source).getAFlowState()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    state = sink.(Sink).getAFlowState()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof Sanitizer and not exists(node.(Sanitizer).getAFlowState())
    or
    node instanceof StringConstCompareBarrier
    or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  override predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) {
    node.(Sanitizer).getAFlowState() = state
  }

  deprecated override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
