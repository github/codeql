/**
 * Provides default sources for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

module DomBasedXss {
  private import Xss::Shared as Shared
  import semmle.javascript.security.CommonFlowState

  /** A data flow source for DOM-based XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for DOM-based XSS vulnerabilities. */
  abstract class Sink extends Shared::Sink { }

  /** A sanitizer for DOM-based XSS vulnerabilities. */
  abstract class Sanitizer extends Shared::Sanitizer { }

  /**
   * A barrier guard for any tainted value.
   */
  abstract class BarrierGuard extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /**
     * Holds if this node acts as a barrier for `state`, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e, FlowState state) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      this.blocksExpr(outcome, e, FlowState::fromFlowLabel(label))
    }
  }

  /** A subclass of `BarrierGuard` that is used for backward compatibility with the old data flow library. */
  deprecated final private class BarrierGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BarrierGuard
  {
    override predicate sanitizes(boolean outcome, Expr e) {
      BarrierGuard.super.sanitizes(outcome, e)
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      BarrierGuard.super.sanitizes(outcome, e, label)
    }
  }

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
      any(AngularJS::AngularJSCallNode call).interpretsArgumentAsHtml(this)
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
        instance = API::moduleImport("jsdom").getMember("JSDOM").getInstance().asSource() and
        this = instance.getArgument(0) and
        instance.getOptionArgument(1, "runScripts").mayHaveStringValue("dangerously")
      )
      or
      MooTools::interpretsNodeAsHtml(this)
    }
  }

  /**
   * Holds if `prefix` is a prefix of `htmlString`, which may be interpreted as
   * HTML by a jQuery method.
   */
  predicate isPrefixOfJQueryHtmlString(DataFlow::Node htmlString, DataFlow::Node prefix) {
    prefix = getAPrefixOfJQuerySelectorString(htmlString)
  }

  /**
   * Holds if `prefix` is a prefix of `htmlString`, which may be interpreted as
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
        pragma[only_bind_out](this.analyze()).getAType() = TTString()
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
      forall(string strval | strval = this.getAPrefix() | strval.regexpMatch("(?s)\\s*<.*|"))
    }
  }

  import ClientSideUrlRedirectCustomizations::ClientSideUrlRedirect as ClientSideUrlRedirect

  /**
   * A write to a URL which may execute JavaScript code.
   */
  class WriteUrlSink extends Sink instanceof ClientSideUrlRedirect::Sink {
    WriteUrlSink() { super.isXssSink() }
  }

  /**
   * An expression whose value is interpreted as HTML or CSS
   * and may be inserted into the DOM.
   */
  class DomSink extends Sink {
    DomSink() {
      // Call to a DOM function that inserts its argument into the DOM
      any(DomMethodCallNode call).interpretsArgumentsAsHtml(this)
      or
      // Assignment to a dangerous DOM property
      exists(DomPropertyWrite pw |
        pw.interpretsValueAsHtml() and
        this = pw.getRhs()
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
        isDomNode(ccf.getReceiver()) and
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
        exists(JsxAttribute attr |
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
   * A React tooltip where the `data-html` attribute is set to `true`.
   */
  class TooltipSink extends Sink {
    TooltipSink() {
      exists(JsxElement el |
        el.getAttributeByName("data-html").getStringValue() = "true" or
        el.getAttributeByName("data-html").getValue().mayHaveBooleanValue(true)
      |
        this = el.getAttributeByName("data-tip").getValue().flow()
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
  class VueTemplateSink extends Sink {
    VueTemplateSink() {
      // Note: don't use Vue::Component#getTemplate as it includes an unwanted getALocalSource() step
      this = any(Vue::Component c).getOption("template")
    }
  }

  /**
   * The tag name argument to the `createElement` parameter of the
   * `render` method of a Vue instance, viewed as an XSS sink.
   */
  class VueCreateElementSink extends Sink {
    VueCreateElementSink() {
      exists(Vue::Component c, DataFlow::FunctionNode f |
        f.flowsTo(c.getRender()) and
        this = f.getParameter(0).getACall().getArgument(0)
      )
    }
  }

  /**
   * A Vue `v-html` attribute, viewed as an XSS sink.
   */
  class VHtmlSink extends Vue::VHtmlAttribute, Sink { }

  /**
   * A raw interpolation tag in a template file, viewed as an XSS sink.
   */
  class TemplateSink extends Sink {
    TemplateSink() {
      exists(Templating::TemplatePlaceholderTag tag |
        tag.isRawInterpolation() and
        this = tag.asDataFlowNode()
      )
    }
  }

  /**
   * A write to the `innerHTML` or `outerHTML` property of a DOM element, viewed as an XSS sink.
   *
   * Uses the Angular Renderer2 API, instead of the default `Element.innerHTML` property.
   */
  class AngularRender2SetPropertyInnerHtmlSink2 extends Sink {
    AngularRender2SetPropertyInnerHtmlSink2() {
      exists(Angular2::AngularRenderer2AttributeDefinition attrDef |
        attrDef.getName() = ["innerHTML", "outerHTML"] and
        this = attrDef.getValueNode()
      )
    }
  }

  /**
   * A value being piped into the `safe` pipe in a template file,
   * disabling subsequent HTML escaping.
   */
  class SafePipe extends Sink {
    SafePipe() { this = Templating::getAPipeCall("safe").getArgument(0) }
  }

  /**
   * A property read from a safe property is considered a sanitizer.
   */
  class SafePropertyReadSanitizer extends Sanitizer, DataFlow::Node {
    SafePropertyReadSanitizer() {
      exists(PropAccess pacc | pacc = this.asExpr() | pacc.getPropertyName() = "length")
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

  private class SerializeJavascriptSanitizer extends Sanitizer, Shared::SerializeJavascriptSanitizer
  { }

  private class IsEscapedInSwitchSanitizer extends Sanitizer, Shared::IsEscapedInSwitchSanitizer { }

  private class HtmlSanitizerAsSanitizer extends Sanitizer instanceof HtmlSanitizerCall { }

  /**
   * DEPRECATED. Use `isOptionallySanitizedNode` instead.
   *
   * Holds if there exists two dataflow edges to `succ`, where one edges is sanitized, and the other edge starts with `pred`.
   */
  deprecated predicate isOptionallySanitizedEdge = isOptionallySanitizedEdgeInternal/2;

  bindingset[call]
  pragma[inline_late]
  private SsaVariable getSanitizedSsaVariable(HtmlSanitizerCall call) {
    call.getAnArgument().asExpr().(VarAccess).getVariable() = result.getSourceVariable()
  }

  private predicate isOptionallySanitizedEdgeInternal(DataFlow::Node pred, DataFlow::Node succ) {
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
        getSanitizedSsaVariable(sanitizer) = b
      |
        pred = DataFlow::ssaDefinitionNode(b) and
        succ = DataFlow::ssaDefinitionNode(phi)
      )
    )
  }

  /**
   * Holds if `node` should be considered optionally sanitized as it occurs in a branch
   * that controls whether sanitization is enabled.
   *
   * For example, in `sanitized = sanitize ? sanitizer(source) : source`, the right-hand `source` expression
   * is considered an optionally sanitized node.
   */
  predicate isOptionallySanitizedNode(DataFlow::Node node) {
    isOptionallySanitizedEdgeInternal(_, node)
  }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A flow-label representing tainted values where the prefix is attacker controlled.
   */
  abstract deprecated class PrefixString extends DataFlow::FlowLabel {
    PrefixString() { this = "PrefixString" }
  }

  /** Gets the flow-label representing tainted values where the prefix is attacker controlled. */
  deprecated PrefixString prefixLabel() { any() }

  /**
   * A sanitizer that blocks the `PrefixString` label when the start of the string is being tested as being of a particular prefix.
   */
  abstract class PrefixStringSanitizer extends BarrierGuard instanceof StringOps::StartsWith {
    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      e = super.getBaseString().asExpr() and
      state.isTaintedPrefix() and
      outcome = super.getPolarity()
    }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("html-injection").asSink() }
  }
}
