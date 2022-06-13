/**
 * Provides classes for working with untrusted flow sources from the `github.com/revel/revel` package.
 */

import go
private import semmle.go.security.OpenUrlRedirectCustomizations

/** Provides classes and methods modeling the Revel web framework. */
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
   * The `Render` and `RenderTemplate` methods are handled by `TemplateRender` below.
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

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
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

  /**
   * A read in a Revel template that uses Revel's `raw` function.
   */
  class RawTemplateRead extends HtmlTemplate::TemplateRead {
    RawTemplateRead() { parent.getBody().regexpMatch("(?s)raw\\s.*") }
  }

  /**
   * A write to a template argument field that is read raw inside of a template.
   */
  private class RawTemplateArgument extends HTTP::TemplateResponseBody::Range {
    RawTemplateRead read;

    RawTemplateArgument() {
      exists(TemplateRender render, VariableWithFields var |
        render.getRenderedFile() = read.getFile() and
        // if var is a.b.c, any rhs of a write to a, a.b, or a.b.cb
        this = var.getParent*().getAWrite().getRhs()
      |
        var.getParent*() = render.getArgumentVariable() and
        (
          var = read.getReadVariable(render.getArgumentVariable())
          or
          // if no write or use of that variable exists, no VariableWithFields will be generated
          // so we try to find a parent VariableWithFields
          // this isn't covered by the 'getParent*' above because no match would be found at all
          // for var
          not exists(read.getReadVariable(render.getArgumentVariable())) and
          exists(string fieldName | fieldName = read.getFieldName() |
            var.getQualifiedName() =
              render.getArgumentVariable().getQualifiedName() +
                ["." + fieldName.substring(0, fieldName.indexOf(".")), ""]
          )
        )
        or
        // a revel controller.Render(arg) will set controller.ViewArgs["arg"] = arg
        exists(Variable arg | arg.getARead() = render.(ControllerRender).getAnArgument() |
          var.getBaseVariable() = arg and
          var.getQualifiedName() = read.getFieldName()
        )
      )
    }

    override string getAContentType() { result = "text/html" }

    override HTTP::ResponseWriter getResponseWriter() { none() }

    override HtmlTemplate::TemplateRead getRead() { result = read }
  }

  /**
   * A render of a template.
   */
  abstract class TemplateRender extends DataFlow::Node, TemplateInstantiation::Range {
    /** Gets the name of the file that is rendered. */
    abstract File getRenderedFile();

    /** Gets the variable passed as an argument to the template. */
    abstract VariableWithFields getArgumentVariable();

    override DataFlow::Node getADataArgument() { result = this.getArgumentVariable().getAUse() }
  }

  private IR::EvalInstruction skipImplicitFieldReads(IR::Instruction insn) {
    result = insn or
    result = skipImplicitFieldReads(insn.(IR::ImplicitFieldReadInstruction).getBase())
  }

  /** A call to `Controller.Render`. */
  private class ControllerRender extends TemplateRender, DataFlow::MethodCallNode {
    ControllerRender() { this.getTarget().hasQualifiedName(packagePath(), "Controller", "Render") }

    override DataFlow::Node getTemplateArgument() { none() }

    override File getRenderedFile() {
      exists(Type controllerType, string controllerRe, string handlerRe, string pathRe |
        controllerType = skipImplicitFieldReads(this.getReceiver().asInstruction()).getResultType() and
        controllerRe = "\\Q" + controllerType.getName() + "\\E" and
        handlerRe = "\\Q" + this.getRoot().(FuncDef).getName() + "\\E" and
        // find a file named '/views/<controller>/<handler>(.<template type>).html
        pathRe = "/views/" + controllerRe + "/" + handlerRe + "(\\..*)?\\.html?"
      |
        result.getAbsolutePath().regexpMatch("(?i).*" + pathRe)
      )
    }

    override VariableWithFields getArgumentVariable() {
      exists(VariableWithFields base | base.getAUse().getASuccessor*() = this.getReceiver() |
        result.getParent() = base and
        result.getField().getName() = "ViewArgs"
      )
    }
  }

  /** A call to `Controller.RenderTemplate`. */
  private class ControllerRenderTemplate extends TemplateRender, DataFlow::MethodCallNode {
    ControllerRenderTemplate() {
      this.getTarget().hasQualifiedName(packagePath(), "Controller", "RenderTemplate")
    }

    override DataFlow::Node getTemplateArgument() { result = this.getArgument(0) }

    override File getRenderedFile() {
      exists(string pathRe | pathRe = "\\Q" + this.getTemplateArgument().getStringValue() + "\\E" |
        result.getAbsolutePath().regexpMatch(".*/" + pathRe)
      )
    }

    override VariableWithFields getArgumentVariable() {
      exists(VariableWithFields base | base.getAUse().getASuccessor*() = this.getReceiver() |
        result.getParent() = base and
        result.getField().getName() = "ViewArgs"
      )
    }
  }
}
