/**
 * Provides classes and predicates used by the XSS queries.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

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
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  class MetacharEscapeSanitizer extends Sanitizer, StringReplaceCall {
    MetacharEscapeSanitizer() {
      exists(RegExpConstant c |
        c.getLiteral() = getRegExp().asExpr() and
        c.getValue().regexpMatch("['\"&<>]")
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

  private import semmle.javascript.security.dataflow.IncompleteHtmlAttributeSanitizationCustomizations::IncompleteHtmlAttributeSanitization as IncompleteHTML

  /**
   * A guard that checks if a string can contain quotes, which is a guard for strings that are inside a HTML attribute.
   */
  class QuoteGuard extends SanitizerGuard, StringOps::Includes {
    QuoteGuard() {
      this.getSubstring().mayHaveStringValue("\"") and
      this
          .getBaseString()
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
  class ContainsHTMLGuard extends SanitizerGuard, StringOps::RegExpTest {
    ContainsHTMLGuard() {
      exists(RegExpCharacterClass regExp |
        regExp = getRegExp() and
        forall(string s | s = ["\"", "&", "<", ">"] | regExp.getAMatchedString() = s)
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = getPolarity().booleanNot() and e = this.getStringOperand().asExpr()
    }
  }

  /**
   * Holds if `str` is used in a switch-case that has cases matching HTML escaping.
   */
  private predicate isUsedInHTMLEscapingSwitch(Expr str) {
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
  private SsaVariable getAPathEscapedInSwitch() { isUsedInHTMLEscapingSwitch(result.getAUse()) }

  /**
   * An expression that is sanitized by a switch-case.
   */
  class IsEscapedInSwitchSanitizer extends Sanitizer {
    IsEscapedInSwitchSanitizer() { this.asExpr() = getAPathEscapedInSwitch().getAUse() }
  }
}

/** Provides classes and predicates for the DOM-based XSS query. */
module DomBasedXss {
  /** A data flow source for DOM-based XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for DOM-based XSS vulnerabilities. */
  abstract class Sink extends Shared::Sink { }

  /** A sanitizer for DOM-based XSS vulnerabilities. */
  abstract class Sanitizer extends Shared::Sanitizer { }

  /** A sanitizer guard for DOM-based XSS vulnerabilities. */
  abstract class SanitizerGuard extends Shared::SanitizerGuard { }

  /**
   * An expression whose value is interpreted as HTML
   * and may be inserted into the DOM through a library.
   */
  class LibrarySink extends Sink {
    LibrarySink() {
      // call to a jQuery method that interprets its argument as HTML
      exists(JQuery::MethodCall call |
        call.interpretsArgumentAsHtml(this) and
        not call.interpretsArgumentAsSelector(this) // Handled by `JQuerySelectorSink`
      )
      or
      // call to an Angular method that interprets its argument as HTML
      any(AngularJS::AngularJSCall call).interpretsArgumentAsHtml(this.asExpr())
      or
      // call to a WinJS function that interprets its argument as HTML
      exists(DataFlow::MethodCallNode mcn, string m |
        m = "setInnerHTMLUnsafe" or m = "setOuterHTMLUnsafe"
      |
        mcn.getMethodName() = m and
        this = mcn.getArgument(1)
      )
      or
      this = any(Typeahead::TypeaheadSuggestionFunction f).getAReturn()
      or
      this = any(Handlebars::SafeString s).getAnArgument()
      or
      this = any(JQuery::MethodCall call | call.getMethodName() = "jGrowl").getArgument(0)
      or
      // A construction of a JSDOM object (server side DOM), where scripts are allowed.
      exists(DataFlow::NewNode instance |
        instance = API::moduleImport("jsdom").getMember("JSDOM").getInstance().getAnImmediateUse() and
        this = instance.getArgument(0) and
        instance.getOptionArgument(1, "runScripts").mayHaveStringValue("dangerously")
      )
    }
  }

  /**
   * Holds if `prefix` is a prefix of `htmlString`, which may be intepreted as
   * HTML by a jQuery method.
   */
  predicate isPrefixOfJQueryHtmlString(DataFlow::Node htmlString, DataFlow::Node prefix) {
    prefix = getAPrefixOfJQuerySelectorString(htmlString)
  }

  /**
   * Holds if `prefix` is a prefix of `htmlString`, which may be intepreted as
   * HTML by a jQuery method.
   */
  private DataFlow::Node getAPrefixOfJQuerySelectorString(DataFlow::Node htmlString) {
    any(JQuery::MethodCall call).interpretsArgumentAsSelector(htmlString) and
    result = htmlString
    or
    exists(DataFlow::Node pred | pred = getAPrefixOfJQuerySelectorString(htmlString) |
      result = StringConcatenation::getFirstOperand(pred)
      or
      result = pred.getAPredecessor()
    )
  }

  /**
   * An argument to the jQuery `$` function or similar, which is interpreted as either a selector
   * or as an HTML string depending on its first character.
   */
  class JQueryHtmlOrSelectorArgument extends DataFlow::Node {
    JQueryHtmlOrSelectorArgument() {
      exists(JQuery::MethodCall call |
        call.interpretsArgumentAsHtml(this) and
        call.interpretsArgumentAsSelector(this) and
        analyze().getAType() = TTString()
      )
    }

    /** Gets a string that flows to the prefix of this argument. */
    string getAPrefix() { result = getAPrefixOfJQuerySelectorString(this).getStringValue() }
  }

  /**
   * An argument to the jQuery `$` function or similar, which may be interpreted as HTML.
   *
   * This is the same as `JQueryHtmlOrSelectorArgument`, excluding cases where the value
   * is prefixed by something other than `<`.
   */
  class JQueryHtmlOrSelectorSink extends Sink, JQueryHtmlOrSelectorArgument {
    JQueryHtmlOrSelectorSink() {
      // If a prefix of the string is known, it must start with '<' or be an empty string
      forall(string strval | strval = getAPrefix() | strval.regexpMatch("(?s)\\s*<.*|"))
    }
  }

  /**
   * An expression whose value is interpreted as HTML or CSS
   * and may be inserted into the DOM.
   */
  class DomSink extends Sink {
    DomSink() {
      // Call to a DOM function that inserts its argument into the DOM
      any(DomMethodCallExpr call).interpretsArgumentsAsHTML(this.asExpr())
      or
      // Assignment to a dangerous DOM property
      exists(DomPropWriteNode pw |
        pw.interpretsValueAsHTML() and
        this = DataFlow::valueNode(pw.getRhs())
      )
      or
      // `html` or `source.html` properties of React Native `WebView`
      exists(ReactNative::WebViewElement webView, DataFlow::SourceNode source |
        source = webView or
        source = webView.getAPropertyWrite("source").getRhs().getALocalSource()
      |
        this = source.getAPropertyWrite("html").getRhs()
      )
    }
  }

  /**
   * An expression whose value is interpreted as HTML.
   */
  class HtmlParserSink extends Sink {
    HtmlParserSink() {
      exists(DataFlow::GlobalVarRefNode domParser |
        domParser.getName() = "DOMParser" and
        this = domParser.getAnInstantiation().getAMethodCall("parseFromString").getArgument(0)
      )
      or
      exists(DataFlow::MethodCallNode ccf |
        isDomValue(ccf.getReceiver().asExpr()) and
        ccf.getMethodName() = "createContextualFragment" and
        this = ccf.getArgument(0)
      )
    }
  }

  /**
   * A React `dangerouslySetInnerHTML` attribute, viewed as an XSS sink.
   *
   * Any write to the `__html` property of an object assigned to this attribute
   * is considered an XSS sink.
   */
  class DangerouslySetInnerHtmlSink extends Sink, DataFlow::ValueNode {
    DangerouslySetInnerHtmlSink() {
      exists(DataFlow::Node danger, DataFlow::SourceNode valueSrc |
        exists(JSXAttribute attr |
          attr.getName() = "dangerouslySetInnerHTML" and
          attr.getValue() = danger.asExpr()
        )
        or
        exists(ReactElementDefinition def, DataFlow::ObjectLiteralNode props |
          props.flowsTo(def.getProps()) and
          props.hasPropertyWrite("dangerouslySetInnerHTML", danger)
        )
      |
        valueSrc.flowsTo(danger) and
        valueSrc.hasPropertyWrite("__html", this)
      )
    }
  }

  /**
   * The HTML body of an email, viewed as an XSS sink.
   */
  class EmailHtmlBodySink extends Sink {
    EmailHtmlBodySink() { this = any(EmailSender sender).getHtmlBody() }

    override string getVulnerabilityKind() { result = "HTML injection" }
  }

  /**
   * A write to the `template` option of a Vue instance, viewed as an XSS sink.
   */
  class VueTemplateSink extends DomBasedXss::Sink {
    VueTemplateSink() { this = any(Vue::Instance i).getTemplate() }
  }

  /**
   * The tag name argument to the `createElement` parameter of the
   * `render` method of a Vue instance, viewed as an XSS sink.
   */
  class VueCreateElementSink extends DomBasedXss::Sink {
    VueCreateElementSink() {
      exists(Vue::Instance i, DataFlow::FunctionNode f |
        f.flowsTo(i.getRender()) and
        this = f.getParameter(0).getACall().getArgument(0)
      )
    }
  }

  /**
   * A Vue `v-html` attribute, viewed as an XSS sink.
   */
  class VHtmlSink extends DomBasedXss::Sink {
    HTML::Attribute attr;

    VHtmlSink() {
      this.(DataFlow::HtmlAttributeNode).getAttribute() = attr and attr.getName() = "v-html"
    }

    /**
     * Gets the HTML attribute of this sink.
     */
    HTML::Attribute getAttr() { result = attr }
  }

  /**
   * A taint propagating data flow edge through a string interpolation of a
   * Vue instance property to a `v-html` attribute.
   *
   * As an example, `<div v-html="prop"/>` reads the `prop` property
   * of `inst = new Vue({ ..., data: { prop: source } })`, if the
   * `div` element is part of the template for `inst`.
   */
  class VHtmlSourceWrite extends TaintTracking::AdditionalTaintStep {
    VHtmlSink attr;

    VHtmlSourceWrite() {
      exists(Vue::Instance instance, string expr |
        attr.getAttr().getRoot() =
          instance.getTemplateElement().(Vue::Template::HtmlElement).getElement() and
        expr = attr.getAttr().getValue() and
        // only support for simple identifier expressions
        expr.regexpMatch("(?i)[a-z0-9_]+") and
        this = instance.getAPropertyValue(expr)
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = this and succ = attr
    }
  }

  /**
   * A property read from a safe property is considered a sanitizer.
   */
  class SafePropertyReadSanitizer extends Sanitizer, DataFlow::Node {
    SafePropertyReadSanitizer() {
      exists(PropAccess pacc | pacc = this.asExpr() |
        isSafeLocationProperty(pacc)
        or
        pacc.getPropertyName() = "length"
      )
    }
  }

  /**
   * A sanitizer that reads the first part a location split by "?", e.g. `location.href.split('?')[0]`.
   */
  class QueryPrefixSanitizer extends Sanitizer {
    StringSplitCall splitCall;

    QueryPrefixSanitizer() {
      this = splitCall.getASubstringRead(0) and
      splitCall.getSeparator() = "?" and
      splitCall.getBaseString().getALocalSource() =
        [DOM::locationRef(), DOM::locationRef().getAPropertyRead("href")]
    }
  }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, Shared::MetacharEscapeSanitizer { }

  private class UriEncodingSanitizer extends Sanitizer, Shared::UriEncodingSanitizer { }

  private class IsEscapedInSwitchSanitizer extends Sanitizer, Shared::IsEscapedInSwitchSanitizer { }

  private class QuoteGuard extends SanitizerGuard, Shared::QuoteGuard { }

  /**
   * Holds if there exists two dataflow edges to `succ`, where one edges is sanitized, and the other edge starts with `pred`.
   */
  predicate isOptionallySanitizedEdge(DataFlow::Node pred, DataFlow::Node succ) {
    exists(HtmlSanitizerCall sanitizer |
      // sanitized = sanitize ? sanitizer(source) : source;
      exists(ConditionalExpr branch, Variable var, VarAccess access |
        branch = succ.asExpr() and access = var.getAnAccess()
      |
        branch.getABranch() = access and
        pred.getEnclosingExpr() = access and
        sanitizer = branch.getABranch().flow() and
        sanitizer.getAnArgument().getEnclosingExpr() = var.getAnAccess()
      )
      or
      // sanitized = source; if (sanitize) {sanitized = sanitizer(source)};
      exists(SsaPhiNode phi, SsaExplicitDefinition a, SsaDefinition b |
        a = phi.getAnInput().getDefinition() and
        b = phi.getAnInput().getDefinition() and
        count(phi.getAnInput()) = 2 and
        not a = b and
        sanitizer = DataFlow::valueNode(a.getDef().getSource()) and
        sanitizer.getAnArgument().asExpr().(VarAccess).getVariable() = b.getSourceVariable()
      |
        pred = DataFlow::ssaDefinitionNode(b) and
        succ = DataFlow::ssaDefinitionNode(phi)
      )
    )
  }

  private class ContainsHTMLGuard extends SanitizerGuard, Shared::ContainsHTMLGuard { }
}

/** Provides classes and predicates for the reflected XSS query. */
module ReflectedXss {
  /** A data flow source for reflected XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for reflected XSS vulnerabilities. */
  abstract class Sink extends Shared::Sink { }

  /** A sanitizer for reflected XSS vulnerabilities. */
  abstract class Sanitizer extends Shared::Sanitizer { }

  /** A sanitizer guard for reflected XSS vulnerabilities. */
  abstract class SanitizerGuard extends Shared::SanitizerGuard { }

  /**
   * An expression that is sent as part of an HTTP response, considered as an XSS sink.
   *
   * We exclude cases where the route handler sets either an unknown content type or
   * a content type that does not (case-insensitively) contain the string "html". This
   * is to prevent us from flagging plain-text or JSON responses as vulnerable.
   */
  class HttpResponseSink extends Sink, DataFlow::ValueNode {
    override HTTP::ResponseSendArgument astNode;

    HttpResponseSink() { not exists(getANonHtmlHeaderDefinition(astNode)) }
  }

  /**
   * Gets a HeaderDefinition that defines a non-html content-type for `send`.
   */
  HTTP::HeaderDefinition getANonHtmlHeaderDefinition(HTTP::ResponseSendArgument send) {
    exists(HTTP::RouteHandler h |
      send.getRouteHandler() = h and
      result = nonHtmlContentTypeHeader(h)
    |
      // The HeaderDefinition affects a response sent at `send`.
      headerAffects(result, send)
    )
  }

  /**
   * Holds if `h` may send a response with a content type other than HTML.
   */
  HTTP::HeaderDefinition nonHtmlContentTypeHeader(HTTP::RouteHandler h) {
    result = h.getAResponseHeader("content-type") and
    not exists(string tp | result.defines("content-type", tp) | tp.regexpMatch("(?i).*html.*"))
  }

  /**
   * Holds if a header set in `header` is likely to affect a response sent at `sender`.
   */
  predicate headerAffects(HTTP::HeaderDefinition header, HTTP::ResponseSendArgument sender) {
    sender.getRouteHandler() = header.getRouteHandler() and
    (
      // `sender` is affected by a dominating `header`.
      header.getBasicBlock().(ReachableBasicBlock).dominates(sender.getBasicBlock())
      or
      // There is no dominating header, and `header` is non-local.
      not isLocalHeaderDefinition(header) and
      not exists(HTTP::HeaderDefinition dominatingHeader |
        dominatingHeader.getBasicBlock().(ReachableBasicBlock).dominates(sender.getBasicBlock())
      )
    )
  }

  /**
   * Holds if the HeaderDefinition `header` seems to be local.
   * A HeaderDefinition is local if it dominates exactly one `ResponseSendArgument`.
   *
   * Recognizes variants of:
   * ```
   * response.writeHead(500, ...);
   * response.end('Some error');
   * return;
   * ```
   */
  predicate isLocalHeaderDefinition(HTTP::HeaderDefinition header) {
    exists(ReachableBasicBlock headerBlock |
      headerBlock = header.getBasicBlock().(ReachableBasicBlock)
    |
      1 =
        strictcount(HTTP::ResponseSendArgument sender |
          sender.getRouteHandler() = header.getRouteHandler() and
          header.getBasicBlock().(ReachableBasicBlock).dominates(sender.getBasicBlock())
        ) and
      // doesn't dominate something that looks like a callback.
      not exists(Expr e | e instanceof Function | headerBlock.dominates(e.getBasicBlock()))
    )
  }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, Shared::MetacharEscapeSanitizer { }

  private class UriEncodingSanitizer extends Sanitizer, Shared::UriEncodingSanitizer { }

  private class IsEscapedInSwitchSanitizer extends Sanitizer, Shared::IsEscapedInSwitchSanitizer { }

  private class QuoteGuard extends SanitizerGuard, Shared::QuoteGuard { }

  private class ContainsHTMLGuard extends SanitizerGuard, Shared::ContainsHTMLGuard { }
}

/** Provides classes and predicates for the stored XSS query. */
module StoredXss {
  /** A data flow source for stored XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for stored XSS vulnerabilities. */
  abstract class Sink extends Shared::Sink { }

  /** A sanitizer for stored XSS vulnerabilities. */
  abstract class Sanitizer extends Shared::Sanitizer { }

  /** A sanitizer guard for stored XSS vulnerabilities. */
  abstract class SanitizerGuard extends Shared::SanitizerGuard { }

  /** An arbitrary XSS sink, considered as a flow sink for stored XSS. */
  private class AnySink extends Sink {
    AnySink() { this instanceof Shared::Sink }
  }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, Shared::MetacharEscapeSanitizer { }

  private class UriEncodingSanitizer extends Sanitizer, Shared::UriEncodingSanitizer { }

  private class IsEscapedInSwitchSanitizer extends Sanitizer, Shared::IsEscapedInSwitchSanitizer { }

  private class QuoteGuard extends SanitizerGuard, Shared::QuoteGuard { }

  private class ContainsHTMLGuard extends SanitizerGuard, Shared::ContainsHTMLGuard { }
}

/** Provides classes and predicates for the XSS through DOM query. */
module XssThroughDom {
  /** A data flow source for XSS through DOM vulnerabilities. */
  abstract class Source extends Shared::Source { }
}
