/**
 * Provides models of the [go-restful library](https://github.com/emicklei/go-restful).
 */

import go

/**
 * Provides models of the [go-restful library](https://github.com/emicklei/go-restful).
 */
private module GoRestfulHttp {
  /** Gets the package name `github.com/emicklei/go-restful`. */
  string packagePath() { result = package("github.com/emicklei/go-restful", "") }

  /**
   * A model for methods defined on go-restful's `Request` object that may return user-controlled data.
   */
  private class GoRestfulSourceMethod extends Method {
    GoRestfulSourceMethod() {
      this.hasQualifiedName(packagePath(), "Request",
        [
          "QueryParameters", "QueryParameter", "BodyParameter", "HeaderParameter", "PathParameter",
          "PathParameters"
        ])
    }
  }

  /**
   * A model of go-restful's `Request` object as a source of user-controlled data.
   */
  private class GoRestfulSource extends UntrustedFlowSource::Range {
    GoRestfulSource() { this = any(GoRestfulSourceMethod g).getACall() }
  }

  /**
   * A model of go-restful's `Request.ReadEntity` method as a source of user-controlled data.
   */
  private class GoRestfulReadEntitySource extends UntrustedFlowSource::Range {
    GoRestfulReadEntitySource() {
      exists(DataFlow::MethodCallNode call |
        call.getTarget().hasQualifiedName(packagePath(), "Request", "ReadEntity")
      |
        this = FunctionOutput::parameter(0).getExitNode(call)
      )
    }
  }
}
