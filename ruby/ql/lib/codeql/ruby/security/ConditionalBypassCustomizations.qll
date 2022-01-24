/**
 * Provides default sources, sinks, and sanitizers for reasoning about bypass of
 * sensitive action guards, as well as extension points for adding your own.
 */

private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.BasicBlocks
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.security.SensitiveActions

/**
 * Provides default sources, sinks, and sanitizers for reasoning about bypass of
 * sensitive action guards, as well as extension points for adding your own.
 */
module ConditionalBypass {
  /**
   * A data flow source for bypass of sensitive action guards.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for bypass of sensitive action guards.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the guarded sensitive action.
     */
    abstract SensitiveAction getAction();
  }

  /**
   * A sanitizer for bypass of sensitive action guards.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source for bypass of
   * sensitive action guards.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A conditional that guards a sensitive action, e.g. `ok` in `if (ok) login()`.
   */
  class SensitiveActionGuardConditional extends Sink {
    SensitiveAction action;

    SensitiveActionGuardConditional() {
      exists(ConditionBlock cb, BasicBlock controlled |
        cb.controls(controlled, _) and
        controlled.getANode() = action.asExpr() and
        cb.getLastNode() = this.asExpr()
      )
    }

    override SensitiveAction getAction() { result = action }
  }
}
