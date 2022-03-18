/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unvalidated URL redirection problems on the client side, as well as
 * extension points for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module ClientSideUrlRedirect {
  /**
   * A data flow source for unvalidated URL redirect vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow label to associate with this source. */
    DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }
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
   * A flow label for values that represent the URL of the current document, and
   * hence are only partially user-controlled.
   */
  abstract class DocumentUrl extends DataFlow::FlowLabel {
    DocumentUrl() { this = "document.url" }
  }

  /** A source of remote user input, considered as a flow source for unvalidated URL redirects. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() {
      this instanceof RemoteFlowSource and
      not this.(ClientSideRemoteFlowSource).getKind().isPath()
    }

    override DataFlow::FlowLabel getAFlowLabel() {
      if this.(ClientSideRemoteFlowSource).getKind().isUrl()
      then result instanceof DocumentUrl
      else result.isTaint()
    }
  }

  /**
   * DEPRECATED. Can usually be replaced with `untrustedUrlSubstring`.
   * Query accesses via `location.hash` or `location.search` are now independent
   * `RemoteFlowSource` instances, and only substrings of `location` need to be handled via steps.
   */
  deprecated predicate queryAccess = untrustedUrlSubstring/2;

  /**
   * Holds if `substring` refers to a substring of `base` which is considered untrusted
   * when `base` is the current URL.
   */
  predicate untrustedUrlSubstring(DataFlow::Node base, DataFlow::Node substring) {
    exists(MethodCallExpr mce, string methodName |
      mce = substring.asExpr() and mce.calls(base.asExpr(), methodName)
    |
      methodName = "split" and
      // exclude all splits where only the prefix is accessed, which is safe for url-redirects.
      not exists(PropAccess pacc | mce = pacc.getBase() | pacc.getPropertyName() = "0")
      or
      methodName = StringOps::substringMethodName() and
      // exclude `location.href.substring(0, ...)` and similar, which can
      // never refer to the query string
      not mce.getArgument(0).(NumberLiteral).getIntValue() = 0
    )
    or
    exists(MethodCallExpr mce |
      substring.asExpr() = mce and
      mce = any(DataFlow::RegExpCreationNode re).getAMethodCall("exec").asExpr() and
      base.asExpr() = mce.getArgument(0)
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
      // An assignment to `location`
      exists(Assignment assgn | isLocation(assgn.getTarget()) and astNode = assgn.getRhs()) and
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
        this.asExpr() = service.getAMethodCall("url").getArgument(0)
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
      any(DomMethodCallExpr call).interpretsArgumentsAsURL(this.asExpr())
    }

    override predicate isXssSink() { any() }
  }

  /**
   * A write of an attribute which may execute JavaScript code or
   * exfiltrate data to an attacker controlled site.
   */
  class AttributeWriteUrlSink extends ScriptUrlSink, DataFlow::ValueNode {
    AttributeWriteUrlSink() {
      exists(DomPropWriteNode pw |
        pw.interpretsValueAsJavaScriptUrl() and
        this = DataFlow::valueNode(pw.getRhs())
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
  }

  /**
   * A call to change the current url with a Next.js router.
   */
  class NextRoutePushUrlSink extends ScriptUrlSink {
    NextRoutePushUrlSink() {
      this = NextJS::nextRouter().getAMemberCall(["push", "replace"]).getArgument(0)
    }
  }
}
