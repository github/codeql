/**
 * Provides classes for working with remote flow sources from the `github.com/revel/revel` package.
 */

import go
private import semmle.go.security.OpenUrlRedirectCustomizations

/** Provides classes and methods modeling the Revel web framework. */
module Revel {
  /** Gets the package name `github.com/revel/revel`. */
  string packagePath() {
    result = package(["github.com/revel", "github.com/robfig"] + "/revel", "")
  }

  private class ParamsFixedSanitizer extends TaintTracking::DefaultTaintSanitizer,
    DataFlow::FieldReadNode
  {
    ParamsFixedSanitizer() {
      exists(Field f |
        this.readsField(_, f) and
        f.hasQualifiedName(packagePath(), "Params", "Fixed")
      )
    }
  }

  private string contentTypeFromFilename(DataFlow::Node filename) {
    if filename.getStringValue().regexpMatch("(?i).*\\.html?")
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
  private class ControllerRenderMethods extends Http::ResponseBody::Range {
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
        this = methodCall.getASyntacticArgument()
      )
    }

    override Http::ResponseWriter getResponseWriter() { none() }

    override string getAContentType() { result = contentType }
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
  private class RawTemplateArgument extends Http::TemplateResponseBody::Range {
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
        exists(Variable arg | arg.getARead() = render.(ControllerRender).getASyntacticArgument() |
          var.getBaseVariable() = arg and
          var.getQualifiedName() = read.getFieldName()
        )
      )
    }

    override string getAContentType() { result = "text/html" }

    override Http::ResponseWriter getResponseWriter() { none() }

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
