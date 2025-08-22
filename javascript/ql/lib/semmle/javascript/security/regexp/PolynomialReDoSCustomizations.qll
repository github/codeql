/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * polynomial regular expression denial-of-service attacks, as well
 * as extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.regexp.RegExpTreeView::RegExpTreeView as TreeView

/** Module containing sources, sinks, and sanitizers for polynomial regular expression denial-of-service attacks. */
module PolynomialReDoS {
  import codeql.regex.nfa.SuperlinearBackTracking::Make<TreeView>

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
   * A barrier guard for polynomial regular expression denial-of-service attacks.
   */
  abstract class BarrierGuard extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }
  }

  /** A subclass of `BarrierGuard` that is used for backward compatibility with the old data flow library. */
  deprecated final private class BarrierGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BarrierGuard
  {
    override predicate sanitizes(boolean outcome, Expr e) {
      BarrierGuard.super.sanitizes(outcome, e)
    }
  }

  /**
   * A remote input to a server, seen as a source for polynomial
   * regular expression denial-of-service vulnerabilities.
   */
  class RequestInputAccessAsSource extends Source instanceof Http::RequestInputAccess {
    override string getKind() { result = Http::RequestInputAccess.super.getKind() }
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
        isCharClassLike(root)
      )
      or
      this.(DataFlow::MethodCallNode).getMethodName() = StringOps::substringMethodName() and
      not this.(DataFlow::MethodCallNode).getNumArgument() = 1 // with one argument it just slices off the beginning
    }
  }

  /**
   * Holds if `term` matches a set of strings of length 1.
   */
  predicate isCharClassLike(RegExpTerm term) {
    term instanceof RegExpCharacterClass
    or
    term instanceof RegExpCharacterClassEscape
    or
    term.(RegExpConstant).getValue().length() = 1
    or
    exists(RegExpAlt alt | term = alt |
      forall(RegExpTerm choice | choice = alt.getAlternative() | isCharClassLike(choice))
    )
    or
    // an infinite repetition of a char class, is effectively the same, because the regex is global.
    exists(InfiniteRepetitionQuantifier quan | term = quan | isCharClassLike(quan.getChild(0)))
  }

  /**
   * An check on the length of a string, seen as a sanitizer guard.
   */
  class LengthGuard extends BarrierGuard, DataFlow::ValueNode {
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

    override predicate blocksExpr(boolean outcome, Expr e) {
      outcome = polarity and
      e = input.asExpr()
    }
  }

  private import semmle.javascript.PackageExports as Exports

  /**
   * A parameter of an exported function, seen as a source for polynomial-redos.
   */
  class ExternalInputSource extends Source {
    ExternalInputSource() { this = Exports::getALibraryInputParameter() }

    override string getKind() { result = "library" }

    override string describe() { result = "library input" }
  }
}
