/**
 * Provides classes for working with the `github.com/gin-gonic/gin` package.
 */

import go
private import semmle.go.security.HardcodedCredentials

private module Gin {
  /** Gets the package name `github.com/gin-gonic/gin`. */
  string packagePath() { result = package("github.com/gin-gonic/gin", "") }

  /**
   * A call to a method on `Context` struct that unmarshals data into a target.
   */
  private class GithubComGinGonicGinContextBindSource extends RemoteFlowSource::Range {
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

  /**
   * The File system access sinks
   */
  class FsOperations extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathArg;

    FsOperations() {
      exists(Method m |
        (
          m.hasQualifiedName(packagePath(), "Context", ["File", "FileAttachment"]) and
          pathArg = 0
          or
          m.hasQualifiedName(packagePath(), "Context", "SaveUploadedFile") and
          pathArg = 1
        ) and
        this = m.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
  }

  private class GinJwtSign extends HardcodedCredentials::Sink {
    GinJwtSign() {
      exists(Field f |
        f.hasQualifiedName(package("github.com/appleboy/gin-jwt", ""), "GinJWTMiddleware", "Key") and
        f.getAWrite().getRhs() = this
      )
    }
  }
}
