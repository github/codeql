/**
 * Provides classes representing external location sinks.
 */

import csharp
private import Remote
private import semmle.code.csharp.commons.Loggers
private import semmle.code.csharp.frameworks.system.Web

/**
 * An external location sink.
 *
 * These sinks are used to write data to locations that are external to the application, and over
 * which the application may have no access control. For example, files on a local or remote
 * filesystem (including log files and cookies).
 */
abstract class ExternalLocationSink extends DataFlow::ExprNode { }

/**
 * An argument to a call to a method on a logger class.
 */
class LogMessageSink extends ExternalLocationSink {
  LogMessageSink() { this.getExpr() = any(LoggerType i).getAMethod().getACall().getAnArgument() }
}

/**
 * An argument to a call to a method on a `Trace` or `TraceSource` class.
 */
class TraceMessageSink extends ExternalLocationSink {
  TraceMessageSink() {
    exists(Class trace, string parameterName |
      trace.hasQualifiedName("System.Diagnostics", "Trace") or
      trace.hasQualifiedName("System.Diagnostics", "TraceSource")
    |
      this.getExpr() = trace.getAMethod().getACall().getArgumentForName(parameterName) and
      (
        parameterName = "format" or
        parameterName = "args" or
        parameterName = "message" or
        parameterName = "category"
      )
    )
  }
}

/**
 * An expression set as a value on a cookie instance.
 */
class CookieStorageSink extends ExternalLocationSink, RemoteFlowSink {
  CookieStorageSink() {
    exists(Expr e | e = this.getExpr() |
      e = any(SystemWebHttpCookie cookie).getAConstructor().getACall().getArgumentForName("value")
      or
      // Anything set on the Value property
      e =
        any(SystemWebHttpCookie cookie).getProperty("Value").getSetter().getACall().getAnArgument()
      or
      // Anything set on any index of the `Values` property
      e = any(SystemWebHttpCookie cookie).getValuesProperty().getAnIndexerCall().getArgument(1)
      or
      // Anything set on any index of the cookie itself
      e = any(SystemWebHttpCookie cookie).getAnIndexer().getSetter().getACall().getArgument(1)
    )
  }
}
