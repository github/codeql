/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * polynomial regular expression denial-of-service attacks, as well
 * as extension points for adding your own.
 */

private import codeql.ruby.AST as AST
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.Regexp
private import codeql.ruby.security.performance.SuperlinearBackTracking

module PolynomialReDoS {
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
   * A sanitizer guard for polynomial regular expression denial of service
   * vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

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
              op.getExpr() instanceof AST::RegExpMatchExpr or
              op.getExpr() instanceof AST::NoRegExpMatchExpr
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
        )
      )
    }

    override RegExpTerm getRegExp() { result = term }

    override DataFlow::Node getHighlight() { result = matchNode }
  }

  /**
   * A check on the length of a string, seen as a sanitizer guard.
   */
  class LengthGuard extends SanitizerGuard, CfgNodes::ExprNodes::RelationalOperationCfgNode {
    private DataFlow::Node input;

    LengthGuard() {
      exists(DataFlow::CallNode length, DataFlow::ExprNode operand |
        length.asExpr().getExpr().(AST::MethodCall).getMethodName() = "length" and
        length.getReceiver() = input and
        length.flowsTo(operand) and
        operand.getExprNode() = this.getAnOperand()
      )
    }

    override predicate checks(CfgNode node, boolean branch) {
      node = input.asExpr() and branch = true
    }
  }
}
