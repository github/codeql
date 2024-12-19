private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.Frameworks
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.frameworks.data.internal.ApiGraphModels

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Code injection" vulnerabilities, as well as extension points for
 * adding your own.
 */
module CodeInjection {
  /** Flow states used to distinguish whether an attacker controls the entire string. */
  module FlowState {
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
    /** Gets a flow state for which this is a source. */
    FlowState::State getAState() {
      result instanceof FlowState::SubString or result instanceof FlowState::Full
    }
  }

  /**
   * A data flow sink for "Code injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
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

    override FlowState::State getAState() { result instanceof FlowState::Full }
  }

  private class ExternalCodeInjectionSink extends Sink {
    ExternalCodeInjectionSink() { this = ModelOutput::getASinkNode("code-injection").asSink() }
  }
}
