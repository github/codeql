/**
 * Provides classes for working with untrusted flow sources, sinks and taint propagators
 * from the `github.com/beego/beego` package.
 */

import go
import semmle.go.security.Xss
private import semmle.go.security.SafeUrlFlowCustomizations

/**
 * Provides classes for working with untrusted flow sources, sinks and taint propagators
 * from the [Beego](`github.com/beego/beego`) package.
 */
module Beego {
  /** Gets the module path `github.com/astaxie/beego` or `github.com/beego/beego`. */
  string modulePath() { result = ["github.com/astaxie/beego", "github.com/beego/beego"] }

  /** Gets the path for the root package of beego. */
  string packagePath() { result = package(modulePath(), "") }

  /** Gets the path for the context package of beego. */
  string contextPackagePath() { result = package(modulePath(), "context") }

  /** Gets the path for the logs package of beego. */
  string logsPackagePath() { result = package(modulePath(), "logs") }

  /** Gets the path for the utils package of beego. */
  string utilsPackagePath() { result = package(modulePath(), "utils") }

  /**
   * `BeegoInput` sources of untrusted data.
   */
  private class BeegoInputSource extends UntrustedFlowSource::Range {
    string methodName;
    FunctionOutput output;

    BeegoInputSource() {
      exists(DataFlow::MethodCallNode c | this = output.getExitNode(c) |
        c.getTarget().hasQualifiedName(contextPackagePath(), "BeegoInput", methodName)
      ) and
      (
        methodName = "Bind" and
        output.isParameter(0)
        or
        methodName in [
            "Cookie", "Data", "GetData", "Header", "Param", "Params", "Query", "Refer", "Referer",
            "URI", "URL", "UserAgent"
          ] and
        output.isResult(0)
      )
    }

    predicate isSafeUrlSource() { methodName in ["URI", "URL"] }
  }

  /** `BeegoInput` sources that are safe to use for redirection. */
  private class BeegoInputSafeUrlSource extends SafeUrlFlow::Source {
    BeegoInputSafeUrlSource() { this.(BeegoInputSource).isSafeUrlSource() }
  }

  /**
   * `beego.Controller` sources of untrusted data.
   */
  private class BeegoControllerSource extends UntrustedFlowSource::Range {
    string methodName;
    FunctionOutput output;

    BeegoControllerSource() {
      exists(DataFlow::MethodCallNode c |
        c.getTarget().hasQualifiedName(packagePath(), "Controller", methodName)
      |
        this = output.getExitNode(c)
      ) and
      (
        methodName = "ParseForm" and
        output.isParameter(0)
        or
        methodName in ["GetFile", "GetFiles", "GetString", "GetStrings", "Input"] and
        output.isResult(0)
        or
        methodName = "GetFile" and
        output.isResult(1)
      )
    }
  }

  /**
   * `beego/context.Context` sources of untrusted data.
   */
  private class BeegoContextSource extends UntrustedFlowSource::Range {
    BeegoContextSource() {
      exists(Method m | m.hasQualifiedName(contextPackagePath(), "Context", "GetCookie") |
        this = m.getACall().getResult()
      )
    }
  }

  private class BeegoOutputInstance extends HTTP::ResponseWriter::Range {
    SsaWithFields v;

    BeegoOutputInstance() {
      this = v.getBaseVariable().getSourceVariable() and
      v.getType().(PointerType).getBaseType().hasQualifiedName(contextPackagePath(), "BeegoOutput")
    }

    override DataFlow::Node getANode() { result = v.similar().getAUse().getASuccessor*() }

    /** Gets a header object that corresponds to this HTTP response. */
    DataFlow::MethodCallNode getAHeaderObject() {
      result.getTarget().getName() = ["ContentType", "Header"] and
      this.getANode() = result.getReceiver()
    }
  }

  private class BeegoHeaderWrite extends HTTP::HeaderWrite::Range, DataFlow::MethodCallNode {
    string methodName;

    BeegoHeaderWrite() {
      this.getTarget().hasQualifiedName(contextPackagePath(), "BeegoOutput", methodName) and
      methodName in ["ContentType", "Header"]
    }

    override DataFlow::Node getName() { methodName = "Header" and result = this.getArgument(0) }

    override string getHeaderName() {
      result = HTTP::HeaderWrite::Range.super.getHeaderName()
      or
      methodName = "ContentType" and result = "content-type"
    }

    override DataFlow::Node getValue() {
      if methodName = "ContentType"
      then result = this.getArgument(0)
      else result = this.getArgument(1)
    }

    override HTTP::ResponseWriter getResponseWriter() {
      result.(BeegoOutputInstance).getAHeaderObject() = this
    }
  }

  private class BeegoResponseBody extends HTTP::ResponseBody::Range {
    DataFlow::MethodCallNode call;
    string methodName;

    BeegoResponseBody() {
      exists(Method m | m.hasQualifiedName(contextPackagePath(), "BeegoOutput", methodName) |
        call = m.getACall() and
        this = call.getArgument(0)
      ) and
      methodName in ["Body", "JSON", "JSONP", "ServeFormatted", "XML", "YAML"]
    }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = call.getReceiver() }

    override string getAContentType() {
      // Super-method provides content-types for `Body`, which requires us to search
      // for `ContentType` and `Header` calls against the same `BeegoOutput` instance
      result = super.getAContentType()
      or
      // Specifically describe methods that set the content-type and body in one operation:
      result = "application/json" and methodName = "JSON"
      or
      result = "application/javascript" and methodName = "JSONP"
      or
      // Actually ServeFormatted can serve JSON, XML or YAML depending on the incoming
      // `Accept` header, but the important bit is this method cannot serve text/html.
      result = "application/json" and methodName = "ServeFormatted"
      or
      result = "text/xml" and methodName = "XML"
      or
      result = "application/x-yaml" and methodName = "YAML"
    }
  }

  private class ControllerResponseBody extends HTTP::ResponseBody::Range {
    string name;

    ControllerResponseBody() {
      exists(Method m | m.hasQualifiedName(packagePath(), "Controller", name) |
        name = "CustomAbort" and this = m.getACall().getArgument(1)
        or
        name = "SetData" and this = m.getACall().getArgument(0)
      )
    }

    override HTTP::ResponseWriter getResponseWriter() { none() }

    override string getAContentType() {
      // Actually SetData can serve JSON, XML or YAML depending on the incoming
      // `Accept` header, but the important bit is this method cannot serve text/html.
      result = "application/json" and name = "SetData"
      // CustomAbort doesn't specify a content type, so we assume anything could happen.
    }
  }

  private class ContextResponseBody extends HTTP::ResponseBody::Range {
    string name;

    ContextResponseBody() {
      exists(Method m | m.hasQualifiedName(contextPackagePath(), "Context", name) |
        name = "Abort" and this = m.getACall().getArgument(1)
        or
        name = "WriteString" and this = m.getACall().getArgument(0)
      )
    }

    override HTTP::ResponseWriter getResponseWriter() { none() }

    // Neither method is likely to be used with well-typed data such as JSON output,
    // because there are better methods to do this. Assume the Content-Type could
    // be anything.
    override string getAContentType() { none() }
  }

  private string getALogFunctionName() {
    result =
      [
        "Alert", "Critical", "Debug", "Emergency", "Error", "Info", "Informational", "Notice",
        "Trace", "Warn", "Warning"
      ]
  }

  private class ToplevelBeegoLoggers extends LoggerCall::Range, DataFlow::CallNode {
    ToplevelBeegoLoggers() {
      this.getTarget().hasQualifiedName([packagePath(), logsPackagePath()], getALogFunctionName())
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  private class BeegoLoggerMethods extends LoggerCall::Range, DataFlow::MethodCallNode {
    BeegoLoggerMethods() {
      this.getTarget().hasQualifiedName(logsPackagePath(), "BeeLogger", getALogFunctionName())
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  private class UtilLoggers extends LoggerCall::Range, DataFlow::CallNode {
    UtilLoggers() { this.getTarget().hasQualifiedName(utilsPackagePath(), "Display") }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  private class TopLevelTaintPropagators extends TaintTracking::FunctionModel {
    string name;

    TopLevelTaintPropagators() {
      this.hasQualifiedName(packagePath(), name) and
      name in ["HTML2str", "Htmlquote", "Htmlunquote", "MapGet", "ParseForm", "Str2html", "Substr"]
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      name in ["HTML2str", "Htmlquote", "Htmlunquote", "MapGet", "Str2html", "Substr"] and
      input.isParameter(0) and
      output.isResult(0)
      or
      name = "ParseForm" and
      input.isParameter(0) and
      output.isParameter(1)
    }
  }

  private class ContextTaintPropagators extends TaintTracking::FunctionModel {
    ContextTaintPropagators() { this.hasQualifiedName(contextPackagePath(), "WriteBody") }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(2) and output.isParameter(1)
    }
  }

  private class HtmlQuoteSanitizer extends SharedXss::Sanitizer {
    HtmlQuoteSanitizer() {
      exists(DataFlow::CallNode c | c.getTarget().hasQualifiedName(packagePath(), "Htmlquote") |
        this = c.getArgument(0)
      )
    }
  }

  private class FsOperations extends FileSystemAccess::Range, DataFlow::CallNode {
    FsOperations() {
      this.getTarget().hasQualifiedName(packagePath(), "Walk")
      or
      exists(Method m | this = m.getACall() |
        m.hasQualifiedName(packagePath(), "FileSystem", "Open") or
        m.hasQualifiedName(packagePath(), "Controller", "SaveToFile")
      )
    }

    override DataFlow::Node getAPathArgument() {
      this.getTarget().getName() = ["Walk", "SaveToFile"] and result = this.getArgument(1)
      or
      this.getTarget().getName() = "Open" and result = this.getArgument(0)
    }
  }

  private class RedirectMethods extends HTTP::Redirect::Range, DataFlow::CallNode {
    string package;
    string className;

    RedirectMethods() {
      (
        package = packagePath() and className = "Controller"
        or
        package = contextPackagePath() and className = "Context"
      ) and
      this = any(Method m | m.hasQualifiedName(package, className, "Redirect")).getACall()
    }

    override DataFlow::Node getUrl() {
      className = "Controller" and result = this.getArgument(0)
      or
      className = "Context" and result = this.getArgument(1)
    }

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }

  private class UtilsTaintPropagators extends TaintTracking::FunctionModel {
    string name;

    UtilsTaintPropagators() {
      this.hasQualifiedName(utilsPackagePath(), name) and
      name in [
          "GetDisplayString", "SliceChunk", "SliceDiff", "SliceFilter", "SliceIntersect",
          "SliceMerge", "SlicePad", "SliceRand", "SliceReduce", "SliceShuffle", "SliceUnique"
        ]
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      name in [
          "GetDisplayString", "SliceIntersect", "SliceMerge", "SlicePad", "SliceRand",
          "SliceShuffle", "SliceUnique"
        ] and
      input.isParameter(_) and
      output.isResult(0)
      or
      name in ["SliceChunk", "SliceDiff", "SliceFilter", "SliceReduce"] and
      input.isParameter(0) and
      output.isResult(0)
    }
  }

  private class BeeMapModels extends TaintTracking::FunctionModel, Method {
    string name;

    BeeMapModels() {
      this.hasQualifiedName(utilsPackagePath(), "BeeMap", name) and
      name in ["Get", "Set", "Items"]
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      name = "Set" and input.isParameter(1) and output.isReceiver()
      or
      name in ["Get", "Items"] and input.isReceiver() and output.isResult(0)
    }
  }
}
