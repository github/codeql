/**
 * Provides classes representing data flow sinks for remote user output.
 */

import csharp
private import Email::Email
private import ExternalLocationSink
private import Html
private import semmle.code.csharp.security.dataflow.XSSSinks as XSSSinks
private import semmle.code.csharp.frameworks.system.web.UI

/** A data flow sink of remote user output. */
abstract class RemoteFlowSink extends DataFlow::Node { }

/**
 * A value written to the `[Inner]Text` property of an object defined in the
 * `System.Web.UI` namespace.
 */
class SystemWebUIText extends RemoteFlowSink {
  SystemWebUIText() {
    exists(Property p, string name |
      p.getDeclaringType().getNamespace().getParentNamespace*() instanceof SystemWebUINamespace and
      this.asExpr() = p.getAnAssignedValue() and
      p.hasName(name)
    |
      name = "Text"
      or
      name = "InnerText"
    )
  }
}
