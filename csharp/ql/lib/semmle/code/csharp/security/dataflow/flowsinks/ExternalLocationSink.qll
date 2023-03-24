/**
 * Provides classes representing external location sinks.
 */

import csharp
private import Remote
private import semmle.code.csharp.commons.Loggers
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.system.IO
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.DataFlow

/**
 * An external location sink.
 *
 * These sinks are used to write data to locations that are external to the application, and over
 * which the application may have no access control. For example, files on a local or remote
 * filesystem (including log files and cookies).
 */
abstract class ExternalLocationSink extends DataFlow::ExprNode { }

private class ExternalModelSink extends ExternalLocationSink {
  ExternalModelSink() { sinkNode(this, "remote") }
}

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
      parameterName = ["format", "args", "message", "category"]
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

private predicate isFileWriteCall(Expr stream, Expr data) {
  exists(MethodCall mc, Method m | mc.getTarget() = m.getAnOverrider*() |
    mc.getTarget().hasQualifiedName("System.IO", "Stream", ["Write", "WriteAsync"]) and
    stream = mc.getQualifier() and
    data = mc.getArgument(0)
    or
    mc.getTarget()
        .hasQualifiedName("System.IO", "TextWriter",
          ["Write", "WriteAsync", "WriteLine", "WriteLineAsync"]) and
    stream = mc.getQualifier() and
    data = mc.getArgument(0)
    or
    mc.getTarget().hasQualifiedName("System.Xml.Linq", "XDocument", ["Save", "SaveAsync"]) and
    data = mc.getQualifier() and
    stream = mc.getArgument(0)
  )
}

private module LocalFileOutputStreamConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(MethodCall mc | mc = src.asExpr() |
      mc.getTarget().hasQualifiedName("System.IO", "File", ["Open", "Create", "OpenWrite"])
      or
      mc.getTarget()
          .hasQualifiedName("System.IO", "FileInfo",
            ["AppendText", "Create", "CreateText", "Open", "OpenText", "OpenWrite"])
    )
    or
    exists(ObjectCreation oc | oc = src.asExpr() |
      oc.getObjectType() instanceof SystemIOStreamWriterClass and
      oc.getArgument(0).getType() instanceof StringType
    )
  }

  predicate isSink(DataFlow::Node sink) { isFileWriteCall(sink.asExpr(), _) }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr()
        .(ObjectCreation)
        .getObjectType()
        .hasQualifiedName("System.Security.Cryptography", "CryptoStream")
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ObjectCreation oc |
      node2.asExpr() = oc and
      node1.asExpr() = oc.getArgument(0) and
      oc.getObjectType() instanceof SystemIOStreamWriterClass
    )
  }
}

private module LocalFileOutputStreamFlow = DataFlow::Make<LocalFileOutputStreamConfig>;

class LocalFileOutputSink extends ExternalLocationSink {
  LocalFileOutputSink() {
    exists(DataFlow::Node streamSink |
      LocalFileOutputStreamFlow::hasFlow(_, streamSink) and
      isFileWriteCall(streamSink.asExpr(), this.asExpr())
    )
  }
}
