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
   * A model of go-restful's `Request.ReadEntity` method as a source of user-controlled data.
   */
  private class GoRestfulReadEntitySource extends RemoteFlowSource::Range {
    GoRestfulReadEntitySource() {
      exists(DataFlow::MethodCallNode call |
        call.getTarget().hasQualifiedName(packagePath(), "Request", "ReadEntity")
      |
        this = FunctionOutput::parameter(0).getExitNode(call)
      )
    }
  }
}
