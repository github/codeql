/**
 * Provides classes and predicates used by the XSS queries.
 */

import javascript

/** Provides classes and predicates shared between the XSS queries. */
module Shared {
  /** A data flow source for XSS vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for XSS vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the kind of vulnerability to report in the alert message.
     *
     * Defaults to `Cross-site scripting`, but may be overridden for sinks
     * that do not allow script injection, but injection of other undesirable HTML elements.
     */
    string getVulnerabilityKind() { result = "Cross-site scripting" }
  }

  // import the various XSS query customizations, they populate the shared classes
  private import DomBasedXssCustomizations
  private import ReflectedXssCustomizations
  private import StoredXssCustomizations
  private import XssThroughDomCustomizations
  private import ExceptionXssCustomizations

  /** A sanitizer for XSS vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A global regexp replacement involving the `<`, `'`, or `"` meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   */
  class MetacharEscapeSanitizer extends Sanitizer, StringReplaceCall {
    MetacharEscapeSanitizer() {
      this.isGlobal() and
      (
        RegExp::alwaysMatchesMetaCharacter(this.getRegExp().getRoot(), ["<", "'", "\""])
        or
        // or it's like a wild-card.
        RegExp::isWildcardLike(this.getRegExp().getRoot())
      )
    }
  }

  /**
   * A call to `encodeURI` or `encodeURIComponent`, viewed as a sanitizer for
   * XSS vulnerabilities.
   */
  class UriEncodingSanitizer extends Sanitizer, DataFlow::CallNode {
    UriEncodingSanitizer() {
      exists(string name | this = DataFlow::globalVarRef(name).getACall() |
        name = "encodeURI" or name = "encodeURIComponent"
      )
    }
  }

  /**
   * A call to `serialize-javascript`, which prevents XSS vulnerabilities unless
   * the `unsafe` option is set to `true`.
   */
  class SerializeJavascriptSanitizer extends Sanitizer, DataFlow::CallNode {
    SerializeJavascriptSanitizer() {
      this = DataFlow::moduleImport("serialize-javascript").getACall() and
      not this.getOptionArgument(1, "unsafe").mayHaveBooleanValue(true)
    }
  }

  private import semmle.javascript.security.dataflow.IncompleteHtmlAttributeSanitizationCustomizations::IncompleteHtmlAttributeSanitization as IncompleteHtml

  /**
   * A guard that checks if a string can contain quotes, which is a guard for strings that are inside an HTML attribute.
   */
  abstract class QuoteGuard extends TaintTracking::SanitizerGuardNode, StringOps::Includes {
    QuoteGuard() {
      this.getSubstring().mayHaveStringValue("\"") and
      this.getBaseString()
          .getALocalSource()
          .flowsTo(any(IncompleteHtml::HtmlAttributeConcatenation attributeConcat))
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      e = this.getBaseString().getEnclosingExpr() and outcome = this.getPolarity().booleanNot()
    }
  }

  /**
   * A sanitizer guard that checks for the existence of HTML chars in a string.
   * E.g. `/["'&<>]/.exec(str)`.
   */
  abstract class ContainsHtmlGuard extends TaintTracking::SanitizerGuardNode, StringOps::RegExpTest {
    ContainsHtmlGuard() {
      exists(RegExpCharacterClass regExp |
        regExp = this.getRegExp() and
        forall(string s | s = ["\"", "&", "<", ">"] | regExp.getAMatchedString() = s)
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = this.getPolarity().booleanNot() and e = this.getStringOperand().asExpr()
    }
  }

  /**
   * Holds if `str` is used in a switch-case that has cases matching HTML escaping.
   */
  private predicate isUsedInHtmlEscapingSwitch(Expr str) {
    exists(SwitchStmt switch |
      // "\"".charCodeAt(0) == 34, "&".charCodeAt(0) == 38, "<".charCodeAt(0) == 60
      forall(int c | c = [34, 38, 60] | c = switch.getACase().getExpr().getIntValue()) and
      exists(DataFlow::MethodCallNode mcn | mcn.getMethodName() = "charCodeAt" |
        mcn.flowsToExpr(switch.getExpr()) and
        str = mcn.getReceiver().asExpr()
      )
      or
      forall(string c | c = ["\"", "&", "<"] | c = switch.getACase().getExpr().getStringValue()) and
      (
        exists(DataFlow::MethodCallNode mcn | mcn.getMethodName() = "charAt" |
          mcn.flowsToExpr(switch.getExpr()) and
          str = mcn.getReceiver().asExpr()
        )
        or
        exists(DataFlow::PropRead read | exists(read.getPropertyNameExpr()) |
          read.flowsToExpr(switch.getExpr()) and
          str = read.getBase().asExpr()
        )
      )
    )
  }

  /**
   * Gets an Ssa variable that is used in a sanitizing switch statement.
   * The `pragma[noinline]` is to avoid materializing a cartesian product.
   */
  pragma[noinline]
  private SsaVariable getAPathEscapedInSwitch() { isUsedInHtmlEscapingSwitch(result.getAUse()) }

  /**
   * An expression that is sanitized by a switch-case.
   */
  class IsEscapedInSwitchSanitizer extends Sanitizer {
    IsEscapedInSwitchSanitizer() { this.asExpr() = getAPathEscapedInSwitch().getAUse() }
  }
}
