/**
 * Provides classes for working with untrusted flow sources from the `github.com/revel/revel` package.
 */

import go

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
}
