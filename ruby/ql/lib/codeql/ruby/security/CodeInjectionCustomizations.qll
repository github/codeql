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
    /**
     * Flow state used for normal tainted data, where an attacker might only control a substring.
     * DEPRECATED: Use `Full()`
     */
    deprecated DataFlow::FlowState substring() { result = "substring" }

    /**
     * Flow state used for data that is entirely controlled by the attacker.
     * DEPRECATED: Use `Full()`
     */
    deprecated DataFlow::FlowState full() { result = "full" }

    private newtype TState =
      TFull() or
      TSubString()

    /** A flow state used to distinguish whether an attacker controls the entire string. */
    class State extends TState {
      /**
       * Gets a string representation of this state.
       */
      string toString() { result = this.getStringRepresentation() }

      /**
       * Gets a canonical string representation of this state.
       */
      string getStringRepresentation() {
        this = TSubString() and result = "substring"
        or
        this = TFull() and result = "full"
      }
    }

    /**
     * A flow state used for normal tainted data, where an attacker might only control a substring.
     */
    class SubString extends State, TSubString { }

    /**
     * A flow state used for data that is entirely controlled by the attacker.
     */
    class Full extends State, TFull { }
  }

  /**
   * A data flow source for "Code injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow state for which this is a source.
     * DEPRECATED: Use `getAState()`
     */
    deprecated DataFlow::FlowState getAFlowState() {
      result = [FlowState::substring(), FlowState::full()]
    }

    /** Gets a flow state for which this is a source. */
    FlowState::State getAState() {
      result instanceof FlowState::SubString or result instanceof FlowState::Full
    }
  }

  /**
   * A data flow sink for "Code injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Holds if this sink is safe for an attacker that only controls a substring.
     * DEPRECATED: Use `getAState()`
     */
    deprecated DataFlow::FlowState getAFlowState() {
      result = [FlowState::substring(), FlowState::full()]
    }

    /** Holds if this sink is safe for an attacker that only controls a substring. */
    FlowState::State getAState() { any() }
  }

  /**
   * A sanitizer for "Code injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node {
    /**
     * Gets a flow state for which this is a sanitizer.
     * Sanitizes all states if the result is empty.
     * DEPRECATED: Use `getAState()`
     */
    deprecated DataFlow::FlowState getAFlowState() { none() }

    /**
     * Gets a flow state for which this is a sanitizer.
     * Sanitizes all states if the result is empty.
     */
    FlowState::State getAState() { none() }
  }

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

    deprecated override DataFlow::FlowState getAFlowState() {
      if c.runsArbitraryCode()
      then result = [FlowState::substring(), FlowState::full()] // If it runs arbitrary code then it's always vulnerable.
      else result = FlowState::full() // If it "just" loads something, then it's only vulnerable if the attacker controls the entire string.
    }

    override FlowState::State getAState() {
      if c.runsArbitraryCode()
      then any() // If it runs arbitrary code then it's always vulnerable.
      else result instanceof FlowState::Full // If it "just" loads something, then it's only vulnerable if the attacker controls the entire string.
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

    deprecated override DataFlow::FlowState getAFlowState() { result = FlowState::full() }

    override FlowState::State getAState() { result instanceof FlowState::Full }
  }
}
