/**
 * Provides classes for working with untrusted flow sources from the `github.com/revel/revel` package.
 */

import go
private import semmle.go.security.OpenUrlRedirectCustomizations

module Revel {
  /** Gets the package name. */
  bindingset[result]
  string packagePath() { result = package(["github.com/revel", "github.com/robfig"], "revel") }

  private class ControllerParams extends UntrustedFlowSource::Range, DataFlow::FieldReadNode {
    ControllerParams() {
      exists(Field f |
        this.readsField(_, f) and
        f.hasQualifiedName(packagePath(), "Controller", "Params")
      )
    }
  }

  private class ParamsFixedSanitizer extends TaintTracking::DefaultTaintSanitizer,
    DataFlow::FieldReadNode {
    ParamsFixedSanitizer() {
      exists(Field f |
        this.readsField(_, f) and
        f.hasQualifiedName(packagePath(), "Params", "Fixed")
      )
    }
  }

  /**
   * Reinstate the usual field propagation rules for fields, which the OpenURLRedirect
   * query usually excludes, for fields of `Params` other than `Params.Fixed`.
   */
  private class PropagateParamsFields extends OpenUrlRedirect::AdditionalStep {
    PropagateParamsFields() { this = "PropagateParamsFields" }

    override predicate hasTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Field f, string field |
        f.hasQualifiedName(packagePath(), "Params", field) and
        field != "Fixed"
      |
        succ.(Read).readsField(pred, f)
      )
    }
  }

  private class ParamsBind extends TaintTracking::FunctionModel, Method {
    ParamsBind() { this.hasQualifiedName(packagePath(), "Params", ["Bind", "BindJSON"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isParameter(0)
    }
  }

  private class RouteMatchParams extends UntrustedFlowSource::Range, DataFlow::FieldReadNode {
    RouteMatchParams() {
      exists(Field f |
        this.readsField(_, f) and
        f.hasQualifiedName(packagePath(), "RouteMatch", "Params")
      )
    }
  }

  /** An access to an HTTP request field whose value may be controlled by an untrusted user. */
  private class UserControlledRequestField extends UntrustedFlowSource::Range,
    DataFlow::FieldReadNode {
    UserControlledRequestField() {
      exists(string fieldName |
        this.getField().hasQualifiedName(packagePath(), "Request", fieldName)
      |
        fieldName in ["In", "Header", "URL", "Form", "MultipartForm"]
      )
    }
  }

  private class UserControlledRequestMethod extends UntrustedFlowSource::Range,
    DataFlow::MethodCallNode {
    UserControlledRequestMethod() {
      this
          .getTarget()
          .hasQualifiedName(packagePath(), "Request",
            ["FormValue", "PostFormValue", "GetQuery", "GetForm", "GetMultipartForm", "GetBody"])
    }
  }

  private class ServerMultipartFormGetFiles extends TaintTracking::FunctionModel, Method {
    ServerMultipartFormGetFiles() {
      this.hasQualifiedName(packagePath(), "ServerMultipartForm", "GetFiles")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class ServerMultipartFormGetValues extends TaintTracking::FunctionModel, Method {
    ServerMultipartFormGetValues() {
      this.hasQualifiedName(packagePath(), "ServerMultipartForm", "GetValues")
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class ServerRequestGet extends TaintTracking::FunctionModel, Method {
    ServerRequestGet() { this.hasQualifiedName(packagePath(), "ServerRequest", "Get") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  private string contentTypeFromFilename(DataFlow::Node filename) {
    if filename.getStringValue().toLowerCase().matches(["%.htm", "%.html"])
    then result = "text/html"
    else result = "application/octet-stream"
    // Actually Revel can figure out a variety of other content-types, but none of our analyses care to
    // distinguish ones other than text/html.
  }

  /**
   * `revel.Controller` methods which set the response content-type to and designate a result in one operation.
   *
   * Note these don't actually generate the response, they return a struct which is then returned by the controller
   * method, but it is very likely if a string is being rendered that it will end up sent to the user.
   *
   * The `Render` and `RenderTemplate` methods are excluded for now because both execute HTML templates, and deciding
   * whether a particular value is exposed unescaped or not requires parsing the template.
   *
   * The `RenderError` method can actually return HTML content, but again only via an HTML template if one exists;
   * we assume it falls back to return plain text as this implies there is probably not an injection opportunity
   * but there is an information leakage issue.
   *
   * The `RenderBinary` method can also return a variety of content-types based on the file extension passed.
   * We look particularly for html file extensions, since these are the only ones we currently have special rules
   * for (in particular, detecting XSS vulnerabilities).
   */
  private class ControllerRenderMethods extends HTTP::ResponseBody::Range {
    string contentType;

    ControllerRenderMethods() {
      exists(Method m, string methodName, DataFlow::CallNode methodCall |
        m.hasQualifiedName(packagePath(), "Controller", methodName) and
        methodCall = m.getACall()
      |
        exists(int exposedArgument |
          this = methodCall.getArgument(exposedArgument) and
          (
            methodName = "RenderBinary" and
            contentType = contentTypeFromFilename(methodCall.getArgument(1)) and
            exposedArgument = 0
            or
            methodName = "RenderError" and contentType = "text/plain" and exposedArgument = 0
            or
            methodName = "RenderHTML" and contentType = "text/html" and exposedArgument = 0
            or
            methodName = "RenderJSON" and contentType = "application/json" and exposedArgument = 0
            or
            methodName = "RenderJSONP" and
            contentType = "application/javascript" and
            exposedArgument = 1
            or
            methodName = "RenderXML" and contentType = "text/xml" and exposedArgument = 0
          )
        )
        or
        methodName = "RenderText" and
        contentType = "text/plain" and
        this = methodCall.getAnArgument()
      )
    }

    override HTTP::ResponseWriter getResponseWriter() { none() }

    override string getAContentType() { result = contentType }
  }

  /**
   * The `revel.Controller.RenderFileName` method, which instructs Revel to open a file and return its contents.
   * We extend FileSystemAccess rather than HTTP::ResponseBody as this will usually mean exposing a user-controlled
   * file rather than the actual contents being user-controlled.
   */
  private class IoUtilFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    IoUtilFileSystemAccess() {
      this =
        any(Method m | m.hasQualifiedName(packagePath(), "Controller", "RenderFileName")).getACall()
    }

    override DataFlow::Node getAPathArgument() { result = getArgument(0) }
  }

  /**
   * The `revel.Controller.Redirect` method.
   *
   * For now I assume that in the context `Redirect(url, value)`, where Revel will `Sprintf(url, value)` internally,
   * it is very likely `url` imposes some mandatory prefix, so `value` isn't truly an open redirect opportunity.
   */
  private class ControllerRedirectMethod extends HTTP::Redirect::Range, DataFlow::CallNode {
    ControllerRedirectMethod() {
      exists(Method m | m.hasQualifiedName(packagePath(), "Controller", "Redirect") |
        this = m.getACall()
      )
    }

    override DataFlow::Node getUrl() { result = this.getArgument(0) }

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }
}
