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
private import codeql.ruby.AST as Ast

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
    node instanceof Sanitizer or
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  override predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) {
    // string concatenations sanitize the `full` state, as an attacker no longer controls the entire string
    exists(Ast::AstNode str |
      str instanceof Ast::StringLiteral
      or
      str instanceof Ast::AddExpr
    |
      node.asExpr().getExpr() = str and
      state = FlowState::full()
    )
  }

  deprecated override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }
}
