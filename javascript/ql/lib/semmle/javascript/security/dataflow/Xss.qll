/**
 * Provides classes and predicates used by the XSS queries.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes // TODO: Try to remove.

/** Provides classes and predicates shared between the XSS queries. */
module Shared {
  /** A data flow source for XSS vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for XSS vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the kind of vulnerability to report in the alert message.
     *
     * Defaults to `Cross-site scripting`, but may be overriden for sinks
     * that do not allow script injection, but injection of other undesirable HTML elements.
     */
    string getVulnerabilityKind() { result = "Cross-site scripting" }
  }

  /** A sanitizer for XSS vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A sanitizer guard for XSS vulnerabilities. */
  abstract class SanitizerGuard extends TaintTracking::SanitizerGuardNode { }

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

  private import semmle.javascript.security.dataflow.IncompleteHtmlAttributeSanitizationCustomizations::IncompleteHtmlAttributeSanitization as IncompleteHTML

  /**
   * A guard that checks if a string can contain quotes, which is a guard for strings that are inside a HTML attribute.
   */
  class QuoteGuard extends SanitizerGuard, StringOps::Includes {
    QuoteGuard() {
      this.getSubstring().mayHaveStringValue("\"") and
      this.getBaseString()
          .getALocalSource()
          .flowsTo(any(IncompleteHTML::HtmlAttributeConcatenation attributeConcat))
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      e = this.getBaseString().getEnclosingExpr() and outcome = this.getPolarity().booleanNot()
    }
  }

  /**
   * A sanitizer guard that checks for the existence of HTML chars in a string.
   * E.g. `/["'&<>]/.exec(str)`.
   */
  class ContainsHtmlGuard extends SanitizerGuard, StringOps::RegExpTest {
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

  /** DEPRECATED: Alias for ContainsHtmlGuard */
  deprecated class ContainsHTMLGuard = ContainsHtmlGuard;

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

/**
 * DEPRECATED: Use the `DomBasedXssCustomizations.qll` file instead.
 * Provides classes and predicates for the DOM-based XSS query.
 */
deprecated module DomBasedXss {
  import DomBasedXssCustomizations::DomBasedXss
}

/**
 * DEPRECATED: Use the `DomBasedXssCustomizations.qll` file instead.
 * Provides classes and predicates for the reflected XSS query.
 */
deprecated module ReflectedXss {
  import ReflectedXssCustomizations::ReflectedXss
}

/**
 * DEPRECATED: Use the `StoredXssCustomizations.qll` file instead.
 * Provides classes and predicates for the stored XSS query.
 */
deprecated module StoredXss {
  import StoredXssCustomizations::StoredXss
}

/**
 * DEPRECATED: Use the `XssThroughDomCustomizations.qll` file instead.
 * Provides classes and predicates for the XSS through DOM query.
 */
deprecated module XssThroughDom {
  import XssThroughDomCustomizations::XssThroughDom
}

/** Provides classes for customizing the `ExceptionXss` query. */
module ExceptionXss {
  /** A data flow source for XSS caused by interpreting exception or error text as HTML. */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow label to associate with this source.
     *
     * For sources that should pass through a `throw/catch` before reaching the sink, use the
     * `NotYetThrown` labe. Otherwise use `taint` (the default).
     */
    DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }

    /**
     * Gets a human-readable description of what type of error this refers to.
     *
     * The result should be capitalized and usable in the context of a noun.
     */
    string getDescription() { result = "Error text" }
  }

  /**
   * A FlowLabel representing tainted data that has not been thrown in an exception.
   * In the js/xss-through-exception query data-flow can only reach a sink after
   * the data has been thrown as an exception, and data that has not been thrown
   * as an exception therefore has this flow label, and only this flow label, associated with it.
   */
  abstract class NotYetThrown extends DataFlow::FlowLabel {
    NotYetThrown() { this = "NotYetThrown" }
  }

  private class XssSourceAsSource extends Source {
    XssSourceAsSource() { this instanceof Shared::Source }

    override DataFlow::FlowLabel getAFlowLabel() { result instanceof NotYetThrown }

    override string getDescription() { result = "Exception text" }
  }

  /**
   * An error produced by validating using `ajv`.
   *
   * Such an error can contain property names from the input if the
   * underlying schema uses `additionalProperties` or `propertyPatterns`.
   *
   * For example, an input of form `{"<img src=x onerror=alert(1)>": 45}` might produce the error
   * `data/<img src=x onerror=alert(1)> should be string`.
   */
  private class JsonSchemaValidationError extends Source {
    JsonSchemaValidationError() {
      this = any(JsonSchema::Ajv::Instance i).getAValidationError().getAnImmediateUse()
      or
      this = any(JsonSchema::Joi::JoiValidationErrorRead r).getAValidationResultAccess(_)
    }

    override string getDescription() { result = "JSON schema validation error" }
  }
}
