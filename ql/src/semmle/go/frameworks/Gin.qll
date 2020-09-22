/**
 * Provides classes for working with untrusted flow sources from the `github.com/gin-gonic/gin` package.
 */

import go

private module Gin {
  /** Gets the package name `github.com/gin-gonic/gin`. */
  private string packagePath() { result = "github.com/gin-gonic/gin" }

  /**
   * Data from a `Context` struct, considered as a source of untrusted flow.
   */
  private class GithubComGinGonicGinContextSource extends UntrustedFlowSource::Range {
    GithubComGinGonicGinContextSource() {
      exists(string typeName | typeName = "Context" |
        // Method calls:
        exists(DataFlow::MethodCallNode call, string methodName |
          call.getTarget().hasQualifiedName(packagePath(), typeName, methodName) and
          (
            methodName = "FullPath"
            or
            methodName = "GetHeader"
            or
            methodName = "QueryArray"
            or
            methodName = "Query"
            or
            methodName = "PostFormArray"
            or
            methodName = "PostForm"
            or
            methodName = "Param"
            or
            methodName = "GetStringSlice"
            or
            methodName = "GetString"
            or
            methodName = "GetRawData"
            or
            methodName = "ClientIP"
            or
            methodName = "ContentType"
            or
            methodName = "Cookie"
            or
            methodName = "GetQueryArray"
            or
            methodName = "GetQuery"
            or
            methodName = "GetPostFormArray"
            or
            methodName = "GetPostForm"
            or
            methodName = "DefaultPostForm"
            or
            methodName = "DefaultQuery"
            or
            methodName = "GetPostFormMap"
            or
            methodName = "GetQueryMap"
            or
            methodName = "GetStringMap"
            or
            methodName = "GetStringMapString"
            or
            methodName = "GetStringMapStringSlice"
            or
            methodName = "PostFormMap"
            or
            methodName = "QueryMap"
          )
        |
          this = call.getResult(0)
        )
        or
        // Field reads:
        exists(DataFlow::Field fld |
          fld.hasQualifiedName(packagePath(), typeName, ["Accepted", "Params"]) and
          this = fld.getARead()
        )
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
      exists(string typeName | typeName = "Context" |
        exists(DataFlow::MethodCallNode call, string methodName |
          call.getTarget().hasQualifiedName(packagePath(), typeName, methodName) and
          (
            methodName = "BindJSON" or
            methodName = "BindYAML" or
            methodName = "BindXML" or
            methodName = "BindUri" or
            methodName = "BindQuery" or
            methodName = "BindWith" or
            methodName = "BindHeader" or
            methodName = "MustBindWith" or
            methodName = "Bind" or
            methodName = "ShouldBind" or
            methodName = "ShouldBindBodyWith" or
            methodName = "ShouldBindJSON" or
            methodName = "ShouldBindQuery" or
            methodName = "ShouldBindUri" or
            methodName = "ShouldBindHeader" or
            methodName = "ShouldBindWith" or
            methodName = "ShouldBindXML" or
            methodName = "ShouldBindYAML"
          )
        |
          this = FunctionOutput::parameter(0).getExitNode(call)
        )
      )
    }
  }
}
