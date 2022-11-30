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
  abstract class Source extends DataFlow::Node { }

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
   * DEPRECATED: Use `Sanitizer` instead.
   *
   * A sanitizer guard for polynomial regular expression denial of service
   * vulnerabilities.
   */
  abstract deprecated class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * Gets the AST of a regular expression object that can flow to `node`.
   */
  RegExpTerm getRegExpObjectFromNode(DataFlow::Node node) {
    exists(DataFlow::LocalSourceNode regexp |
      regexp.flowsTo(node) and
      result = regexp.asExpr().(CfgNodes::ExprNodes::RegExpLiteralCfgNode).getExpr().getParsed()
    )
  }

  /**
   * A regexp match against a superlinear backtracking term, seen as a sink for
   * polynomial regular expression denial-of-service vulnerabilities.
   */
  class PolynomialBackTrackingTermMatch extends Sink {
    PolynomialBackTrackingTerm term;
    DataFlow::ExprNode matchNode;

    PolynomialBackTrackingTermMatch() {
      exists(DataFlow::Node regexp |
        term.getRootTerm() = getRegExpObjectFromNode(regexp) and
        (
          // `=~` or `!~`
          exists(CfgNodes::ExprNodes::BinaryOperationCfgNode op |
            matchNode.asExpr() = op and
            (
              op.getExpr() instanceof Ast::RegExpMatchExpr or
              op.getExpr() instanceof Ast::NoRegExpMatchExpr
            ) and
            (
              this.asExpr() = op.getLeftOperand() and regexp.asExpr() = op.getRightOperand()
              or
              this.asExpr() = op.getRightOperand() and regexp.asExpr() = op.getLeftOperand()
            )
          )
          or
          // Any of the methods on `String` that take a regexp.
          exists(CfgNodes::ExprNodes::MethodCallCfgNode call |
            matchNode.asExpr() = call and
            call.getExpr().getMethodName() =
              [
                "[]", "gsub", "gsub!", "index", "match", "match?", "partition", "rindex",
                "rpartition", "scan", "slice!", "split", "sub", "sub!"
              ] and
            this.asExpr() = call.getReceiver() and
            regexp.asExpr() = call.getArgument(0)
          )
          or
          // A call to `match` or `match?` where the regexp is the receiver.
          exists(CfgNodes::ExprNodes::MethodCallCfgNode call |
            matchNode.asExpr() = call and
            call.getExpr().getMethodName() = ["match", "match?"] and
            regexp.asExpr() = call.getReceiver() and
            this.asExpr() = call.getArgument(0)
          )
          or
          // a case-when statement
          exists(CfgNodes::ExprNodes::CaseExprCfgNode caseWhen |
            matchNode.asExpr() = caseWhen and
            this.asExpr() = caseWhen.getValue()
          |
            regexp.asExpr() =
              caseWhen.getBranch(_).(CfgNodes::ExprNodes::WhenClauseCfgNode).getPattern(_)
            or
            regexp.asExpr() =
              caseWhen.getBranch(_).(CfgNodes::ExprNodes::InClauseCfgNode).getPattern()
          )
        )
      )
    }

    override RegExpTerm getRegExp() { result = term }

    override DataFlow::Node getHighlight() { result = matchNode }
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
