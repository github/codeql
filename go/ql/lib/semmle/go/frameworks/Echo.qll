/**
 * Provides classes for working with untrusted flow sources, taint propagators, and HTTP sinks
 * from the `github.com/labstack/echo` package.
 */

import go

private module Echo {
  /** Gets the package name `github.com/labstack/echo`. */
  private string packagePath() { result = package("github.com/labstack/echo", "") }

  /**
   * Data from a `Context` interface method, considered as a source of untrusted flow.
   */
  private class EchoContextSource extends UntrustedFlowSource::Range {
    EchoContextSource() {
      exists(DataFlow::MethodCallNode call, string methodName |
        methodName =
          [
            "Param", "ParamValues", "QueryParam", "QueryParams", "QueryString", "FormValue",
            "FormParams", "FormFile", "MultipartForm", "Cookie", "Cookies"
          ] and
        call.getTarget().hasQualifiedName(packagePath(), "Context", methodName) and
        this = call.getResult(0)
      )
    }
  }

  /**
   * Data from a `Context` interface method that is not generally exploitable for open-redirect attacks.
   */
  private class EchoContextRedirectUnexploitableSource extends Http::Redirect::UnexploitableSource {
    EchoContextRedirectUnexploitableSource() {
      exists(DataFlow::MethodCallNode call, string methodName |
        methodName = ["FormValue", "FormParams", "FormFile", "MultipartForm", "Cookie", "Cookies"] and
        call.getTarget().hasQualifiedName(packagePath(), "Context", methodName) and
        this = call.getResult(0)
      )
    }
  }

  /**
   * A call to a method on `Context` struct that unmarshals data into a target.
   */
  private class EchoContextBinder extends UntrustedFlowSource::Range {
    EchoContextBinder() {
      exists(DataFlow::MethodCallNode call |
        call.getTarget().hasQualifiedName(packagePath(), "Context", "Bind")
      |
        this = FunctionOutput::parameter(0).getExitNode(call)
      )
    }
  }

  /**
   * `echo.Context` methods which set the content-type to `text/html` and write a result in one operation.
   */
  private class EchoHtmlOutputs extends Http::ResponseBody::Range {
    EchoHtmlOutputs() {
      exists(Method m | m.hasQualifiedName(packagePath(), "Context", ["HTML", "HTMLBlob"]) |
        this = m.getACall().getArgument(1)
      )
    }

    override Http::ResponseWriter getResponseWriter() { none() }

    override string getAContentType() { result = "text/html" }
  }

  /**
   * `echo.Context` methods which take a content-type as a parameter.
   */
  private class EchoParameterizedOutputs extends Http::ResponseBody::Range {
    DataFlow::CallNode callNode;

    EchoParameterizedOutputs() {
      exists(Method m | m.hasQualifiedName(packagePath(), "Context", ["Blob", "Stream"]) |
        callNode = m.getACall() and this = callNode.getArgument(2)
      )
    }

    override Http::ResponseWriter getResponseWriter() { none() }

    override DataFlow::Node getAContentTypeNode() { result = callNode.getArgument(1) }
  }

  /**
   * The `echo.Context.Redirect` method.
   */
  private class EchoRedirectMethod extends Http::Redirect::Range, DataFlow::CallNode {
    EchoRedirectMethod() {
      exists(Method m | m.hasQualifiedName(packagePath(), "Context", "Redirect") |
        this = m.getACall()
      )
    }

    override DataFlow::Node getUrl() { result = this.getArgument(1) }

    override Http::ResponseWriter getResponseWriter() { none() }
  }

  /**
   * The File system access sinks
   */
  class FsOperations extends FileSystemAccess::Range, DataFlow::CallNode {
    FsOperations() {
      exists(Method m |
        m.hasQualifiedName(packagePath(), "Context", ["Attachment", "File"]) and
        this = m.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
  }
}
