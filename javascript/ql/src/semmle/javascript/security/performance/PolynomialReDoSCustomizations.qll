/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * polynomial regular expression denial-of-service attacks, as well
 * as extension points for adding your own.
 */

import javascript
import SuperlinearBackTracking

module PolynomialReDoS {
  /**
   * A data flow source node for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink node for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    abstract RegExpTerm getRegExp();
  }

  /**
   * A sanitizer for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A remote input to a server, seen as a source for polynomial
   * regular expression denial-of-service vulnerabilities.
   */
  class RequestInputAccessAsSource extends Source {
    RequestInputAccessAsSource() { this instanceof HTTP::RequestInputAccess }
  }

  /**
   * A use of a superlinear backtracking term, seen as a sink for polynomial
   * regular expression denial-of-service vulnerabilities.
   */
  class PolynomialBackTrackingTermUse extends Sink {
    PolynomialBackTrackingTerm term;

    PolynomialBackTrackingTermUse() {
      exists(DataFlow::MethodCallNode mcn, DataFlow::Node regexp, string name |
        term.getRootTerm() = RegExp::getRegExpFromNode(regexp)
      |
        this = mcn.getArgument(0) and
        regexp = mcn.getReceiver() and
        (
          name = "match" or
          name = "split" or
          name = "matchAll" or
          name = "replace" or
          name = "replaceAll" or
          name = "search"
        )
        or
        this = mcn.getReceiver() and
        regexp = mcn.getArgument(0) and
        (name = "test" or name = "exec")
      )
    }

    override RegExpTerm getRegExp() { result = term }
  }

  /**
   * An operation that limits the length of a string, seen as a sanitizer.
   */
  class StringLengthLimiter extends Sanitizer {
    StringLengthLimiter() {
      this.(StringReplaceCall).isGlobal()
      or
      exists(string name | name = "slice" or name = "substring" or name = "substr" |
        this.(DataFlow::MethodCallNode).getMethodName() = name
      )
    }
  }

  /**
   * An check on the length of a string, seen as a sanitizer guard.
   */
  class LengthGuard extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
    DataFlow::Node input;
    boolean polarity;

    LengthGuard() {
      exists(RelationalComparison cmp, DataFlow::PropRead length |
        this.asExpr() = cmp and
        length.accesses(input, "length")
      |
        length.flowsTo(cmp.getLesserOperand().flow()) and polarity = true
        or
        length.flowsTo(cmp.getGreaterOperand().flow()) and polarity = false
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = polarity and
      e = input.asExpr()
    }
  }
}
