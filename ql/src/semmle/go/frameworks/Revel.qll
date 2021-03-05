/**
 * Provides classes for working with untrusted flow sources from the `github.com/revel/revel` package.
 */

import go
private import semmle.go.security.OpenUrlRedirectCustomizations

/** Provides classes and methods modelling the Revel web framework. */
module Revel {
  /** Gets the package name `github.com/revel/revel`. */
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
        fieldName in [
            "Header", "ContentType", "AcceptLanguages", "Locale", "URL", "Form", "MultipartForm"
          ]
      )
    }
  }

  private class UserControlledRequestMethod extends UntrustedFlowSource::Range,
    DataFlow::MethodCallNode {
    UserControlledRequestMethod() {
      this.getTarget()
          .hasQualifiedName(packagePath(), "Request",
            [
              "FormValue", "PostFormValue", "GetQuery", "GetForm", "GetMultipartForm", "GetBody",
              "Cookie", "GetHttpHeader", "GetRequestURI", "MultipartReader", "Referer", "UserAgent"
            ])
    }
  }

  private class ServerCookieGetValue extends TaintTracking::FunctionModel, Method {
    ServerCookieGetValue() { this.implements(packagePath(), "ServerCookie", "GetValue") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class ServerMultipartFormGetFiles extends TaintTracking::FunctionModel, Method {
    ServerMultipartFormGetFiles() {
      this.implements(packagePath(), "ServerMultipartForm", ["GetFiles", "GetValues"])
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
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
  private class RenderFileNameCall extends FileSystemAccess::Range, DataFlow::CallNode {
    RenderFileNameCall() {
      this =
        any(Method m | m.hasQualifiedName(packagePath(), "Controller", "RenderFileName")).getACall()
    }

    override DataFlow::Node getAPathArgument() { result = getArgument(0) }
  }

  /**
   * The `revel.Controller.Redirect` method.
   *
   * It is currently assumed that a tainted `value` in `Redirect(url, value)`, which calls `Sprintf(url, value)`
   * internally, cannot lead to an open redirect vulnerability.
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

  /**
   * The getter and setter methods of `revel.RevelHeader`.
   *
   * Note we currently don't implement `HeaderWrite` and related concepts, as they are currently only used
   * to track content-type, and directly setting headers does not seem to be the usual way to set the response
   * content-type for this framework. If and when the `HeaderWrite` concept has a more abstract idea of the
   * relationship between header-writes and HTTP responses than looking for a particular `http.ResponseWriter`
   * instance connecting the two, then we may implement it here for completeness.
   */
  private class RevelHeaderMethods extends TaintTracking::FunctionModel {
    FunctionInput input;
    FunctionOutput output;
    string name;

    RevelHeaderMethods() {
      this.(Method).hasQualifiedName(packagePath(), "RevelHeader", name) and
      (
        name = ["Add", "Set"] and input.isParameter([0, 1]) and output.isReceiver()
        or
        name = ["Get", "GetAll"] and input.isReceiver() and output.isResult()
        or
        name = "SetCookie" and input.isParameter(0) and output.isReceiver()
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp = input and outp = output
    }
  }
}
