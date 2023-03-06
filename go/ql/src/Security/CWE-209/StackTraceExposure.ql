/**
 * @name Information exposure through a stack trace
 * @description Information from a stack trace propagates to an external user.
 *              Stack traces can unintentionally reveal implementation details
 *              that are useful to an attacker for developing a subsequent exploit.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.4
 * @precision high
 * @id go/stack-trace-exposure
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import go
import semmle.go.security.InsecureFeatureFlag::InsecureFeatureFlag
import DataFlow::PathGraph

/**
 * A flag indicating the program is in debug or development mode, or that stack
 * dumps have been specifically enabled.
 */
class DebugModeFlag extends FlagKind {
  DebugModeFlag() { this = "debugMode" }

  bindingset[result]
  override string getAFlagName() {
    result.regexpMatch("(?i).*(trace|debug|devel|((en|dis)able|print)stack).*")
  }
}

/**
 * The function `runtime.Stack`, which emits a stack trace.
 */
class StackFunction extends Function {
  StackFunction() { this.hasQualifiedName("runtime", "Stack") }
}

/**
 * The function `runtime/debug.Stack`, which emits a stack trace.
 */
class DebugStackFunction extends Function {
  DebugStackFunction() { this.hasQualifiedName("runtime/debug", "Stack") }
}

/**
 * A taint-tracking configuration that looks for stack traces being written to
 * an HTTP response body without an intervening debug- or development-mode conditional.
 */
class StackTraceExposureConfig extends TaintTracking::Configuration {
  StackTraceExposureConfig() { this = "StackTraceExposureConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::PostUpdateNode).getPreUpdateNode() =
      any(StackFunction f).getACall().getArgument(0) or
    node = any(DebugStackFunction f).getACall().getResult()
  }

  override predicate isSink(DataFlow::Node node) { node instanceof Http::ResponseBody }

  override predicate isSanitizer(DataFlow::Node node) {
    // Sanitise everything controlled by an is-debug-mode check.
    // Imprecision: I don't try to guess which arm of a branch is intended
    // to mean debug mode, and which is production mode.
    exists(ControlFlow::ConditionGuardNode cgn |
      cgn.ensures(any(DebugModeFlag f).getAFlag().getANode(), _)
    |
      cgn.dominates(node.getBasicBlock())
    )
  }
}

from StackTraceExposureConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "HTTP response depends on $@ and may be exposed to an external user.", source.getNode(),
  "stack trace information"
