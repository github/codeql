/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unvalidated URL redirection problems on the client side, as well as
 * extension points for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module ClientSideUrlRedirect {
  private import Xss::DomBasedXss as DomBasedXss

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
  abstract class Sink extends DataFlow::Node { }

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
    LocationSink() {
      // A call to a `window.navigate` or `window.open`
      exists(string name |
        name = "navigate" or
        name = "open" or
        name = "openDialog" or
        name = "showModalDialog"
      |
        this = DataFlow::globalVarRef(name).getACall().getArgument(0)
      )
      or
      // A call to `location.replace` or `location.assign`
      exists(DataFlow::MethodCallNode locationCall, string name |
        locationCall = DOM::locationRef().getAMethodCall(name) and
        this = locationCall.getArgument(0)
      |
        name = "replace" or name = "assign"
      )
      or
      // An assignment to `location`
      exists(Assignment assgn | isLocation(assgn.getTarget()) and astNode = assgn.getRhs())
      or
      // An assignment to `location.href`, `location.protocol` or `location.hostname`
      exists(DataFlow::PropWrite pw, string propName |
        pw = DOM::locationRef().getAPropertyWrite(propName) and
        this = pw.getRhs()
      |
        propName = "href" or propName = "protocol" or propName = "hostname"
      )
      or
      // A redirection using the AngularJS `$location` service
      exists(AngularJS::ServiceReference service |
        service.getName() = "$location" and
        this.asExpr() = service.getAMethodCall("url").getArgument(0)
      )
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
   * A script or iframe `src` attribute, viewed as a `ScriptUrlSink`.
   */
  class SrcAttributeUrlSink extends ScriptUrlSink, DataFlow::ValueNode {
    SrcAttributeUrlSink() {
      exists(DOM::AttributeDefinition attr, string eltName |
        attr.getElement().getName() = eltName and
        (eltName = "script" or eltName = "iframe") and
        attr.getName() = "src" and
        this = attr.getValueNode()
      )
    }
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
  }

  /**
   * A write to an React attribute which may execute JavaScript code.
   */
  class ReactAttributeWriteUrlSink extends ScriptUrlSink {
    ReactAttributeWriteUrlSink() {
      exists(JSXAttribute attr |
        attr.getName() = DOM::getAPropertyNameInterpretedAsJavaScriptUrl() and
        attr.getElement().isHTMLElement()
        or
        DataFlow::moduleImport("next/link").flowsToExpr(attr.getElement().getNameExpr())
      |
        this = attr.getValue().flow()
      )
    }
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
