/**
 * Provides default sources, sinks and sanitizers for reasoning about hard-coded
 * data being interpreted as code, as well as extension points for adding your
 * own.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.security.CodeInjectionCustomizations
private import codeql.ruby.AST as Ast
private import codeql.ruby.controlflow.CfgNodes

/**
 * Provides default sources, sinks and sanitizers for reasoning about hard-coded
 * data being interpreted as code, as well as extension points for adding your
 * own.
 */
module HardcodedDataInterpretedAsCode {
  /**
   * Flow states used to distinguish value-preserving flow from taint flow.
   */
  module FlowState {
    /**
     * Flow states used to distinguish value-preserving flow from taint flow.
     */
    newtype State =
      /** Flow state used to track value-preserving flow. */
      Data() or
      /** Flow state used to tainted data (non-value preserving flow). */
      Taint()
  }

  /**
   * A data flow source for hard-coded data.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow label for which this is a source.
     */
    FlowState::State getALabel() { result = FlowState::Data() }
  }

  /**
   * A data flow sink for code injection.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a description of what kind of sink this is. */
    abstract string getKind();

    /**
     * Gets a flow label for which this is a sink.
     */
    FlowState::State getALabel() {
      // We want to ignore value-flow and only consider taint-flow, since the
      // source is just a hex string, and evaluating that directly will just
      // cause a syntax error.
      result = FlowState::Taint()
    }
  }

  /** A sanitizer for hard-coded data. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A constant string consisting of eight or more hexadecimal characters (including at
   * least one digit), viewed as a source of hard-coded data that should not be
   * interpreted as code.
   */
  private class HexStringSource extends Source {
    HexStringSource() {
      exists(string val |
        this.asExpr().(ExprNodes::StringLiteralCfgNode).getConstantValue().isString(val)
      |
        val.regexpMatch("[0-9a-fA-F]{8,}") and
        val.regexpMatch(".*[0-9].*")
      )
    }
  }

  /**
   * A string literal whose raw text is made up entirely of `\x` escape
   * sequences, viewed as a source of hard-coded data that should not be
   * interpreted as code.
   */
  private class HexEscapedStringSource extends Source {
    HexEscapedStringSource() {
      forex(StringComponentCfgNode c |
        c = this.asExpr().(ExprNodes::StringlikeLiteralCfgNode).getAComponent()
      |
        c.getAstNode().(Ast::StringEscapeSequenceComponent).getRawText().matches("\\x%")
      )
    }
  }

  /**
   * A code injection sink; hard-coded data should not flow here.
   */
  private class DefaultCodeInjectionSink extends Sink instanceof CodeInjection::Sink {
    override string getKind() { result = "code" }
  }

  /**
   * An argument to `require` path; hard-coded data should not flow here.
   */
  private class RequireArgumentSink extends Sink {
    RequireArgumentSink() {
      exists(DataFlow::CallNode require |
        require.getReceiver().getExprNode().getExpr() instanceof Ast::SelfVariableAccess and
        require.getMethodName() = "require"
      |
        this = require.getArgument(0)
      )
    }

    override string getKind() { result = "an import path" }
  }
}
