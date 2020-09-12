/**
 * Provides classes for working with HTTP-related concepts such as requests and responses.
 */

import go

/**
 * Provides models of the go-restful library (https://github.com/emicklei/go-restful).
 */
private module GoRestfulHttp {
  /**
   * A model for methods defined on go-restful's `Request` object that may return user-controlled data.
   */
  private class GoRestfulSourceMethod extends Method {
    GoRestfulSourceMethod() {
      this
          .hasQualifiedName(package("github.com/emicklei/go-restful", ""), "Request",
            ["QueryParameters", "QueryParameter", "BodyParameter", "HeaderParameter",
                "PathParameter", "PathParameters"])
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
        call
            .getTarget()
            .hasQualifiedName(package("github.com/emicklei/go-restful", ""), "Request", "ReadEntity")
      |
        this = any(FunctionOutput output | output.isParameter(0)).getExitNode(call)
      )
    }
  }
}
