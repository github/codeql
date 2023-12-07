/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * polynomial regular expression denial-of-service attacks, as well
 * as extension points for adding your own.
 */

private import codeql.ruby.AST as Ast
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.regexp.RegExpTreeView::RegexTreeView as TreeView
private import codeql.ruby.Regexp as RE
private import codeql.ruby.Concepts

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * polynomial regular expression denial-of-service attacks, as well
 * as extension points for adding your own.
 */
module PolynomialReDoS {
  private import TreeView
  import codeql.regex.nfa.SuperlinearBackTracking::Make<TreeView>

  /**
   * A data flow source node for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a string that describes the source.
     * For use in the alert message.
     */
    string describe() { result = "user-provided value" }
  }

  /**
   * A data flow sink node for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets the regex that is being executed by this node. */
    abstract RegExpTerm getRegExp();

    /** Gets the node to highlight in the alert message. */
    DataFlow::Node getHighlight() { result = this }
  }

  /**
   * A sanitizer for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  private import codeql.ruby.frameworks.core.Gem::Gem as Gem

  /** A library input, considered as a flow source. */
  class LibraryInputAsSource extends Source {
    LibraryInputAsSource() { this = Gem::getALibraryInput() }

    override string describe() { result = "library input" }
  }

  /**
   * A regexp match against a superlinear backtracking term, seen as a sink for
   * polynomial regular expression denial-of-service vulnerabilities.
   */
  class PolynomialBackTrackingTermMatch extends Sink {
    PolynomialBackTrackingTerm term;
    RegexExecution exec;

    PolynomialBackTrackingTermMatch() {
      term.getRootTerm() = RE::getTermForExecution(exec) and
      this = exec.getString()
    }

    override RegExpTerm getRegExp() { result = term }

    override DataFlow::Node getHighlight() { result = exec }
  }

  private predicate lengthGuard(CfgNodes::AstCfgNode g, CfgNode node, boolean branch) {
    exists(DataFlow::Node input, DataFlow::CallNode length, DataFlow::ExprNode operand |
      length.asExpr().getExpr().(Ast::MethodCall).getMethodName() = "length" and
      length.getReceiver() = input and
      length.flowsTo(operand) and
      operand.getExprNode() = g.(CfgNodes::ExprNodes::RelationalOperationCfgNode).getAnOperand() and
      node = input.asExpr() and
      branch = true
    )
  }

  /**
   * A check on the length of a string, seen as a sanitizer guard.
   */
  class LengthGuard extends Sanitizer {
    LengthGuard() { this = DataFlow::BarrierGuard<lengthGuard/3>::getABarrierNode() }
  }
}
