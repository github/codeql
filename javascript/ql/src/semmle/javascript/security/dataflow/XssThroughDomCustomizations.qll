/**
 * Provides default sources for reasoning about
 * cross-site scripting vulnerabilities through the DOM.
 */

import javascript

/**
 * Sources for cross-site scripting vulnerabilities through the DOM.
 */
module XssThroughDom {
  import Xss::XssThroughDom
  private import semmle.javascript.dataflow.InferredTypes
  private import semmle.javascript.security.dataflow.Xss::DomBasedXss as DomBasedXss

  /**
   * Gets an attribute name that could store user-controlled data.
   *
   * Attributes such as "id", "href", and "src" are often used as input to HTML.
   * However, they are either rarely controlable by a user, or already a sink for other XSS vulnerabilities.
   * Such attributes are therefore ignored.
   */
  bindingset[result]
  string unsafeAttributeName() {
    result.regexpMatch("data-.*") or
    result.regexpMatch("aria-.*") or
    result = ["name", "value", "title", "alt"]
  }

  /**
   * A source for text from the DOM from a JQuery method call.
   */
  class JQueryTextSource extends Source, JQuery::MethodCall {
    JQueryTextSource() {
      (
        this.getMethodName() = ["text", "val"] and this.getNumArgument() = 0
        or
        this.getMethodName() = "attr" and
        this.getNumArgument() = 1 and
        forex(InferredType t | t = this.getArgument(0).analyze().getAType() | t = TTString()) and
        this.getArgument(0).mayHaveStringValue(unsafeAttributeName())
      ) and
      // looks like a $("<p>" + ... ) source, which is benign for this query.
      not exists(DataFlow::Node prefix |
        DomBasedXss::isPrefixOfJQueryHtmlString(this.getReceiver()
              .(DataFlow::CallNode)
              .getAnArgument(), prefix)
      |
        prefix.getStringValue().regexpMatch("\\s*<.*")
      )
    }
  }

  /**
   * A source for text from the DOM from a DOM property read or call to `getAttribute()`.
   */
  class DOMTextSource extends Source {
    DOMTextSource() {
      exists(DataFlow::PropRead read | read = this |
        read.getBase().getALocalSource() = DOM::domValueRef() and
        read.mayHavePropertyName(["innerText", "textContent", "value", "name"])
      )
      or
      exists(DataFlow::MethodCallNode mcn | mcn = this |
        mcn.getReceiver().getALocalSource() = DOM::domValueRef() and
        mcn.getMethodName() = "getAttribute" and
        mcn.getArgument(0).mayHaveStringValue(unsafeAttributeName())
      )
    }
  }

  /**
   * A test of form `typeof x === "something"`, preventing `x` from being a string in some cases.
   *
   * This sanitizer helps prune infeasible paths in type-overloaded functions.
   */
  class TypeTestGuard extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
    override EqualityTest astNode;
    Expr operand;
    boolean polarity;

    TypeTestGuard() {
      exists(TypeofTag tag | TaintTracking::isTypeofGuard(astNode, operand, tag) |
        // typeof x === "string" sanitizes `x` when it evaluates to false
        tag = "string" and
        polarity = astNode.getPolarity().booleanNot()
        or
        // typeof x === "object" sanitizes `x` when it evaluates to true
        tag != "string" and
        polarity = astNode.getPolarity()
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      polarity = outcome and
      e = operand
    }
  }
}
