/**
 * Provides classes for working with remote flow sources, sinks and taint propagators
 * from the `github.com/beego/beego` package.
 */

import go
import semmle.go.security.Xss
private import semmle.go.security.SafeUrlFlowCustomizations

// Some TaintTracking::FunctionModel subclasses remain because varargs functions don't work with Models-as-Data sumamries yet.
/**
 * Provides classes for working with remote flow sources, sinks and taint propagators
 * from the [Beego](https://github.com/beego/beego) package.
 */
module Beego {
  /** Gets the v1 module path `github.com/astaxie/beego` or `github.com/beego/beego`. */
  string v1modulePath() { result = ["github.com/astaxie/beego", "github.com/beego/beego"] }

  /** Gets the v2 module path `github.com/beego/beego/v2` */
  string v2modulePath() { result = "github.com/beego/beego/v2" }

  /** Gets the path for the root package of beego. */
  string packagePath() {
    result = package(v1modulePath(), "")
    or
    result = package(v2modulePath(), "server/web")
  }

  /** Gets the path for the context package of beego. */
  string contextPackagePath() {
    result = package(v1modulePath(), "context")
    or
    result = package(v2modulePath(), "server/web/context")
  }

  /** Gets the path for the utils package of beego. */
  string utilsPackagePath() {
    result = package(v1modulePath(), "utils")
    or
    result = package(v2modulePath(), "core/utils")
  }

  /** `BeegoInput` sources that are safe to use for redirection. */
  private class BeegoInputSafeUrlSource extends SafeUrlFlow::Source {
    BeegoInputSafeUrlSource() {
      exists(Method m | m.hasQualifiedName(contextPackagePath(), "BeegoInput", ["URI", "URL"]) |
        this = m.getACall().getResult(0)
      )
    }
  }

  private class BeegoOutputInstance extends Http::ResponseWriter::Range {
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

  private class BeegoHeaderWrite extends Http::HeaderWrite::Range, DataFlow::MethodCallNode {
    string methodName;

    BeegoHeaderWrite() {
      this.getTarget().hasQualifiedName(contextPackagePath(), "BeegoOutput", methodName) and
      methodName in ["ContentType", "Header"]
    }

    override DataFlow::Node getName() { methodName = "Header" and result = this.getArgument(0) }

    override string getHeaderName() {
      result = Http::HeaderWrite::Range.super.getHeaderName()
      or
      methodName = "ContentType" and result = "content-type"
    }

    override DataFlow::Node getValue() {
      if methodName = "ContentType"
      then result = this.getArgument(0)
      else result = this.getArgument(1)
    }

    override Http::ResponseWriter getResponseWriter() {
      result.(BeegoOutputInstance).getAHeaderObject() = this
    }
  }

  private class BeegoResponseBody extends Http::ResponseBody::Range {
    DataFlow::MethodCallNode call;
    string methodName;

    BeegoResponseBody() {
      exists(Method m | m.hasQualifiedName(contextPackagePath(), "BeegoOutput", methodName) |
        call = m.getACall() and
        this = call.getArgument(0)
      ) and
      methodName in ["Body", "JSON", "JSONP", "ServeFormatted", "XML", "YAML"]
    }

    override Http::ResponseWriter getResponseWriter() { result.getANode() = call.getReceiver() }

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

  private class ControllerResponseBody extends Http::ResponseBody::Range {
    string name;

    ControllerResponseBody() {
      exists(Method m | m.hasQualifiedName(packagePath(), "Controller", name) |
        name = "CustomAbort" and this = m.getACall().getArgument(1)
        or
        name = "SetData" and this = m.getACall().getArgument(0)
      )
    }

    override Http::ResponseWriter getResponseWriter() { none() }

    override string getAContentType() {
      // Actually SetData can serve JSON, XML or YAML depending on the incoming
      // `Accept` header, but the important bit is this method cannot serve text/html.
      result = "application/json" and name = "SetData"
      // CustomAbort doesn't specify a content type, so we assume anything could happen.
    }
  }

  private class ContextResponseBody extends Http::ResponseBody::Range {
    ContextResponseBody() {
      exists(Method m, string name | m.hasQualifiedName(contextPackagePath(), "Context", name) |
        name = "Abort" and this = m.getACall().getArgument(1)
        or
        name = "WriteString" and this = m.getACall().getArgument(0)
      )
    }

    override Http::ResponseWriter getResponseWriter() { none() }

    // Neither method is likely to be used with well-typed data such as JSON output,
    // because there are better methods to do this. Assume the Content-Type could
    // be anything.
    override string getAContentType() { none() }
  }

  private class HtmlQuoteSanitizer extends SharedXss::Sanitizer {
    HtmlQuoteSanitizer() {
      exists(DataFlow::CallNode c | c.getTarget().hasQualifiedName(packagePath(), "Htmlquote") |
        this = c.getArgument(0)
      )
    }
  }

  private class UtilsTaintPropagators extends TaintTracking::FunctionModel {
    UtilsTaintPropagators() { this.hasQualifiedName(utilsPackagePath(), "GetDisplayString") }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(_) and
      output.isResult(0)
    }
  }
}
