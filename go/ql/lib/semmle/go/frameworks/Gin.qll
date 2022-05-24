/**
 * Provides classes for working with untrusted flow sources from the `github.com/gin-gonic/gin` package.
 */

import go

private module Gin {
  /** Gets the package name `github.com/gin-gonic/gin`. */
  string packagePath() { result = package("github.com/gin-gonic/gin", "") }

  /**
   * Data from a `Context` struct, considered as a source of untrusted flow.
   */
  private class GithubComGinGonicGinContextSource extends UntrustedFlowSource::Range {
    GithubComGinGonicGinContextSource() {
      // Method calls:
      exists(DataFlow::MethodCallNode call, string methodName |
        call.getTarget().hasQualifiedName(packagePath(), "Context", methodName) and
        methodName in [
            "FullPath", "GetHeader", "QueryArray", "Query", "PostFormArray", "PostForm", "Param",
            "GetStringSlice", "GetString", "GetRawData", "ClientIP", "ContentType", "Cookie",
            "GetQueryArray", "GetQuery", "GetPostFormArray", "GetPostForm", "DefaultPostForm",
            "DefaultQuery", "GetPostFormMap", "GetQueryMap", "GetStringMap", "GetStringMapString",
            "GetStringMapStringSlice", "PostFormMap", "QueryMap"
          ]
      |
        this = call.getResult(0)
      )
      or
      // Field reads:
      exists(DataFlow::Field fld |
        fld.hasQualifiedName(packagePath(), "Context", ["Accepted", "Params"]) and
        this = fld.getARead()
      )
    }
  }

  private class ParamsGet extends TaintTracking::FunctionModel, Method {
    ParamsGet() { this.hasQualifiedName(packagePath(), "Params", "Get") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult(0)
    }
  }

  private class ParamsByName extends TaintTracking::FunctionModel, Method {
    ParamsByName() { this.hasQualifiedName(packagePath(), "Params", "ByName") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  /**
   * A call to a method on `Context` struct that unmarshals data into a target.
   */
  private class GithubComGinGonicGinContextBindSource extends UntrustedFlowSource::Range {
    GithubComGinGonicGinContextBindSource() {
      exists(DataFlow::MethodCallNode call, string methodName |
        call.getTarget().hasQualifiedName(packagePath(), "Context", methodName) and
        methodName in [
            "BindJSON", "BindYAML", "BindXML", "BindUri", "BindQuery", "BindWith", "BindHeader",
            "MustBindWith", "Bind", "ShouldBind", "ShouldBindBodyWith", "ShouldBindJSON",
            "ShouldBindQuery", "ShouldBindUri", "ShouldBindHeader", "ShouldBindWith",
            "ShouldBindXML", "ShouldBindYAML"
          ]
      |
        this = FunctionOutput::parameter(0).getExitNode(call)
      )
    }
  }
}
