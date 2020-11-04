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
  abstract class Source extends DataFlow::Node { }

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
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * Holds if `queryAccess` is an expression that may access the query string
   * of a URL that flows into `nd` (that is, the part after the `?`).
   */
  predicate queryAccess(DataFlow::Node nd, DataFlow::Node queryAccess) {
    exists(string propertyName |
      queryAccess.asExpr().(PropAccess).accesses(nd.asExpr(), propertyName)
    |
      propertyName = "search" or propertyName = "hash"
    )
    or
    exists(MethodCallExpr mce, string methodName |
      mce = queryAccess.asExpr() and mce.calls(nd.asExpr(), methodName)
    |
      methodName = "split" and
      // exclude all splits where only the prefix is accessed, which is safe for url-redirects.
      not exists(PropAccess pacc | mce = pacc.getBase() | pacc.getPropertyName() = "0")
      or
      (methodName = "substring" or methodName = "substr" or methodName = "slice") and
      // exclude `location.href.substring(0, ...)` and similar, which can
      // never refer to the query string
      not mce.getArgument(0).(NumberLiteral).getIntValue() = 0
    )
    or
    exists(MethodCallExpr mce |
      queryAccess.asExpr() = mce and
      mce = any(DataFlow::RegExpCreationNode re).getAMethodCall("exec").asExpr() and
      nd.asExpr() = mce.getArgument(0)
    )
  }

  /**
   * A sanitizer that reads the first part a location split by "?", e.g. `location.href.split('?')[0]`.
   */
  class QueryPrefixSanitizer extends Sanitizer, DomBasedXss::QueryPrefixSanitizer { }

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
}
