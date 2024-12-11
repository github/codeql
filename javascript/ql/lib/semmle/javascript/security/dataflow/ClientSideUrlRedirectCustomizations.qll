/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unvalidated URL redirection problems on the client side, as well as
 * extension points for adding your own.
 */

import javascript
private import semmle.javascript.security.TaintedUrlSuffixCustomizations

module ClientSideUrlRedirect {
  import semmle.javascript.security.CommonFlowState

  /**
   * A data flow source for unvalidated URL redirect vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow state to associate with this source. */
    FlowState getAFlowState() { result.isTaint() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for unvalidated URL redirect vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Holds if the sink can execute JavaScript code in the current context. */
    predicate isXssSink() {
      none() // overwritten in subclasses
    }
  }

  /**
   * A sanitizer for unvalidated URL redirect vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED. Replaced by functionality from the `TaintedUrlSuffix` library.
   *
   * A flow label for values that represent the URL of the current document, and
   * hence are only partially user-controlled.
   */
  deprecated class DocumentUrl = TaintedUrlSuffix::TaintedUrlSuffixLabel;

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() { not this.(ClientSideRemoteFlowSource).getKind().isPath() }

    override FlowState getAFlowState() {
      if this = TaintedUrlSuffix::source() then result.isTaintedUrlSuffix() else result.isTaint()
    }
  }

  /**
   * Holds if `node` extracts a part of a URL that does not contain the suffix.
   */
  pragma[inline]
  deprecated predicate isPrefixExtraction(DataFlow::MethodCallNode node) {
    // Block flow through prefix-extraction `substring(0, ...)` and `split("#")[0]`
    node.getMethodName() = [StringOps::substringMethodName(), "split"] and
    not untrustedUrlSubstring(_, node)
  }

  /**
   * Holds if `substring` refers to a substring of `base` which is considered untrusted
   * when `base` is the current URL.
   */
  deprecated predicate untrustedUrlSubstring(DataFlow::Node base, DataFlow::Node substring) {
    exists(DataFlow::MethodCallNode mcn, string methodName |
      mcn = substring and mcn.calls(base, methodName)
    |
      methodName = "split" and
      // exclude all splits where only the prefix is accessed, which is safe for url-redirects.
      not exists(DataFlow::PropRead pacc | mcn = pacc.getBase() | pacc.getPropertyName() = "0")
      or
      methodName = StringOps::substringMethodName() and
      // exclude `location.href.substring(0, ...)` and similar, which can
      // never refer to the query string
      not mcn.getArgument(0).getIntValue() = 0
    )
    or
    exists(DataFlow::MethodCallNode mcn |
      substring = mcn and
      mcn = any(DataFlow::RegExpCreationNode re).getAMethodCall("exec") and
      base = mcn.getArgument(0)
    )
  }

  /**
   * A sink which is used to set the window location.
   */
  class LocationSink extends Sink, DataFlow::ValueNode {
    boolean xss;

    LocationSink() {
      // A call to a `window.navigate` or `window.open`
      exists(string name | name = ["navigate", "open", "openDialog", "showModalDialog"] |
        this = DataFlow::globalVarRef(name).getACall().getArgument(0)
      ) and
      xss = false
      or
      // A call to `location.replace` or `location.assign`
      exists(DataFlow::MethodCallNode locationCall, string name |
        locationCall = DOM::locationRef().getAMethodCall(name) and
        this = locationCall.getArgument(0)
      |
        name = ["replace", "assign"]
      ) and
      xss = true
      or
      // A call to `navigation.navigate`
      this = DataFlow::globalVarRef("navigation").getAMethodCall("navigate").getArgument(0) and
      xss = true
      or
      // An assignment to `location`
      exists(Assignment assgn |
        isLocationNode(assgn.getTarget().flow()) and astNode = assgn.getRhs()
      ) and
      xss = true
      or
      // An assignment to `location.href`, `location.protocol` or `location.hostname`
      exists(DataFlow::PropWrite pw, string propName |
        pw = DOM::locationRef().getAPropertyWrite(propName) and
        this = pw.getRhs()
      |
        propName = ["href", "protocol", "hostname"] and
        (if propName = "href" then xss = true else xss = false)
      )
      or
      // A redirection using the AngularJS `$location` service
      exists(AngularJS::ServiceReference service |
        service.getName() = "$location" and
        this = service.getAMethodCall("url").getArgument(0)
      ) and
      xss = false
    }

    override predicate isXssSink() { xss = true }
  }

  /**
   * The first argument to a call to `openExternal` seen as a sink for unvalidated URL redirection.
   * Improper use of openExternal can be leveraged to compromise the user's host.
   * When openExternal is used with untrusted content, it can be leveraged to execute arbitrary commands.
   */
  class ElectronShellOpenExternalSink extends Sink {
    ElectronShellOpenExternalSink() {
      this =
        DataFlow::moduleMember("electron", "shell").getAMemberCall("openExternal").getArgument(0)
    }
  }

  /**
   * An expression that may be interpreted as the URL of a script.
   */
  abstract class ScriptUrlSink extends Sink { }

  /**
   * An argument expression to `new Worker(...)`, viewed as
   * a `ScriptUrlSink`.
   */
  class WebWorkerScriptUrlSink extends ScriptUrlSink, DataFlow::ValueNode {
    WebWorkerScriptUrlSink() {
      this = DataFlow::globalVarRef("Worker").getAnInstantiation().getArgument(0)
    }
  }

  /**
   * An argument to `importScripts(..)` - which is used inside `WebWorker`s to import new scripts - viewed as a `ScriptUrlSink`.
   */
  class ImportScriptsSink extends ScriptUrlSink {
    ImportScriptsSink() {
      this = DataFlow::globalVarRef("importScripts").getACall().getAnArgument()
    }
  }

  /**
   * A write to a `href` or similar attribute viewed as a `ScriptUrlSink`.
   */
  class AttributeUrlSink extends ScriptUrlSink {
    AttributeUrlSink() {
      // e.g. `$("<a>", {href: sink}).appendTo("body")`
      exists(DOM::AttributeDefinition attr |
        not attr instanceof JsxAttribute and // handled more precisely in `ReactAttributeWriteUrlSink`.
        attr.getName() = DOM::getAPropertyNameInterpretedAsJavaScriptUrl()
      |
        this = attr.getValueNode()
      )
      or
      // e.g. node.setAttribute("href", sink)
      any(DomMethodCallNode call).interpretsArgumentsAsUrl(this)
    }

    override predicate isXssSink() { any() }
  }

  /**
   * A write of an attribute which may execute JavaScript code or
   * exfiltrate data to an attacker controlled site.
   */
  class AttributeWriteUrlSink extends ScriptUrlSink, DataFlow::ValueNode {
    AttributeWriteUrlSink() {
      exists(DomPropertyWrite pw |
        pw.interpretsValueAsJavaScriptUrl() and
        this = pw.getRhs()
      )
    }

    override predicate isXssSink() { any() }
  }

  /**
   * A write to an React attribute which may execute JavaScript code.
   */
  class ReactAttributeWriteUrlSink extends ScriptUrlSink {
    ReactAttributeWriteUrlSink() {
      exists(JsxAttribute attr |
        attr.getName() = DOM::getAPropertyNameInterpretedAsJavaScriptUrl() and
        attr.getElement().isHtmlElement()
        or
        DataFlow::moduleImport("next/link").flowsToExpr(attr.getElement().getNameExpr())
      |
        this = attr.getValue().flow()
      )
    }

    override predicate isXssSink() { any() }
  }

  /**
   * A write to the location using the [history](https://npmjs.com/package/history) library
   */
  class HistoryWriteUrlSink extends ScriptUrlSink {
    HistoryWriteUrlSink() {
      this = History::getBrowserHistory().getMember(["push", "replace"]).getACall().getArgument(0)
    }

    override predicate isXssSink() { any() }
  }

  /**
   * A call to change the current url with a Next.js router.
   */
  class NextRoutePushUrlSink extends ScriptUrlSink {
    NextRoutePushUrlSink() {
      this = NextJS::nextRouter().getAMemberCall(["push", "replace"]).getArgument(0)
    }

    override predicate isXssSink() { any() }
  }

  /**
   * A `templateUrl` member of an AngularJS directive.
   */
  private class AngularJSTemplateUrlSink extends Sink {
    AngularJSTemplateUrlSink() { this = any(AngularJS::CustomDirective d).getMember("templateUrl") }

    override predicate isXssSink() { any() }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("url-redirection").asSink() }
  }
}
