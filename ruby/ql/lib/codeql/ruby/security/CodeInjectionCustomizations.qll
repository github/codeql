private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.Frameworks
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Code injection" vulnerabilities, as well as extension points for
 * adding your own.
 */
module CodeInjection {
  /** Flow states used to distinguish whether an attacker controls the entire string. */
  module FlowState {
    /** Flow state used for normal tainted data, where an attacker might only control a substring. */
    DataFlow::FlowState substring() { result = "substring" }

    /** Flow state used for data that is entirely controlled by the attacker. */
    DataFlow::FlowState full() { result = "full" }
  }

  /**
   * A data flow source for "Code injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow state for which this is a source. */
    DataFlow::FlowState getAFlowState() { result = [FlowState::substring(), FlowState::full()] }
  }

  /**
   * A data flow sink for "Code injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Holds if this sink is safe for an attacker that only controls a substring. */
    DataFlow::FlowState getAFlowState() { result = [FlowState::substring(), FlowState::full()] }
  }

  /**
   * A sanitizer for "Code injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node {
    /**
     * Gets a flow state for which this is a sanitizer.
     * Sanitizes all states if the result is empty.
     */
    DataFlow::FlowState getAFlowState() { none() }
  }

  /**
   * DEPRECATED: Use `Sanitizer` instead.
   *
   * A sanitizer guard for "Code injection" vulnerabilities.
   */
  abstract deprecated class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A call that evaluates its arguments as Ruby code, considered as a flow sink.
   */
  class CodeExecutionAsSink extends Sink {
    CodeExecution c;

    CodeExecutionAsSink() { this = c.getCode() }

    /** Gets a flow state for which this is a sink. */
    override DataFlow::FlowState getAFlowState() {
      if c.runsArbitraryCode()
      then result = [FlowState::substring(), FlowState::full()] // If it runs arbitrary code then it's always vulnerable.
      else result = FlowState::full() // If it "just" loads something, then it's only vulnerable if the attacker controls the entire string.
    }
  }

  private import codeql.ruby.AST as Ast

  /**
   * A string-concatenation that sanitizes the `full()` state.
   */
  class StringConcatenationSanitizer extends Sanitizer {
    StringConcatenationSanitizer() {
      // string concatenations sanitize the `full` state, as an attacker no longer controls the entire string
      exists(Ast::AstNode str |
        str instanceof Ast::StringLiteral
        or
        str instanceof Ast::AddExpr
      |
        this.asExpr().getExpr() = str
      )
    }

    override DataFlow::FlowState getAFlowState() { result = FlowState::full() }
  }
}
