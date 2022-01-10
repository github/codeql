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
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the kind of source that is being accesed.
     *
     * Is either a kind from `HTTP::RequestInputAccess::getKind()`, or "library".
     */
    abstract string getKind();

    /**
     * Gets a string that describes the source.
     * For use in the alert message.
     */
    string describe() { result = "a user-provided value" }
  }

  /**
   * A data flow sink node for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    abstract RegExpTerm getRegExp();

    /**
     * Gets the node to highlight in the alert message.
     */
    DataFlow::Node getHighlight() { result = this }
  }

  /**
   * A sanitizer for polynomial regular expression denial-of-service vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A remote input to a server, seen as a source for polynomial
   * regular expression denial-of-service vulnerabilities.
   */
  class RequestInputAccessAsSource extends Source instanceof HTTP::RequestInputAccess {
    override string getKind() { result = HTTP::RequestInputAccess.super.getKind() }
  }

  /**
   * A use of a superlinear backtracking term, seen as a sink for polynomial
   * regular expression denial-of-service vulnerabilities.
   */
  class PolynomialBackTrackingTermUse extends Sink {
    PolynomialBackTrackingTerm term;
    DataFlow::MethodCallNode mcn;

    PolynomialBackTrackingTermUse() {
      exists(DataFlow::Node regexp, string name |
        term.getRootTerm() = RegExp::getRegExpFromNode(regexp)
      |
        this = mcn.getArgument(0) and
        regexp = mcn.getReceiver() and
        name = ["match", "split", "matchAll", "replace", "replaceAll", "search"]
        or
        this = mcn.getReceiver() and
        regexp = mcn.getArgument(0) and
        (name = "test" or name = "exec")
      )
    }

    override RegExpTerm getRegExp() { result = term }

    override DataFlow::Node getHighlight() { result = mcn }
  }

  /**
   * An operation that limits the length of a string, seen as a sanitizer.
   */
  class StringLengthLimiter extends Sanitizer {
    StringLengthLimiter() {
      this.(StringReplaceCall).isGlobal() and
      // not lone char classes - they don't remove any repeated pattern.
      not exists(RegExpTerm root | root = this.(StringReplaceCall).getRegExp().getRoot() |
        root instanceof RegExpCharacterClass
        or
        root instanceof RegExpCharacterClassEscape
      )
      or
      this.(DataFlow::MethodCallNode).getMethodName() = StringOps::substringMethodName()
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

  private import semmle.javascript.PackageExports as Exports

  /**
   * A parameter of an exported function, seen as a source for polynomial-redos.
   */
  class ExternalInputSource extends Source, DataFlow::SourceNode {
    ExternalInputSource() { this = Exports::getALibraryInputParameter() }

    override string getKind() { result = "library" }

    override string describe() { result = "library input" }
  }
}
