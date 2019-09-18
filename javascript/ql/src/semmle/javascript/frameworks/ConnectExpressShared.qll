/**
 * Provides classes for working with the shared interfaces of
 * [Connect](https://github.com/senchalabs/connect) and
 * [Express](https://expressjs.com) applications.
 */

import javascript

module ConnectExpressShared {
  /**
   * Gets the parameter of kind `kind` of a Connect/Express route handler function.
   *
   * `kind` is one of: "error", "request", "response", "next".
   */
  SimpleParameter getRouteHandlerParameter(Function routeHandler, string kind) {
    exists(int index, int offset |
      result = routeHandler.getParameter(index + offset) and
      (if routeHandler.getNumParameter() = 4 then offset = 0 else offset = -1)
    |
      kind = "error" and index = 0
      or
      kind = "request" and index = 1
      or
      kind = "response" and index = 2
      or
      kind = "next" and index = 3
    )
  }

  /**
   * A function that looks like a Connect/Express route handler.
   *
   * For example, this could be the function `function(req, res, next){...}`.
   */
  class RouteHandlerCandidate extends HTTP::RouteHandlerCandidate {
    RouteHandlerCandidate() {
      exists(string request, string response, string next, string error |
        (request = "request" or request = "req") and
        (response = "response" or response = "res") and
        next = "next" and
        (error = "error" or error = "err")
      |
        // heuristic: parameter names match the documentation
        astNode.getNumParameter() >= 2 and
        getRouteHandlerParameter(astNode, "request").getName() = request and
        getRouteHandlerParameter(astNode, "response").getName() = response and
        (
          astNode.getNumParameter() >= 3
          implies
          getRouteHandlerParameter(astNode, "next").getName() = next
        ) and
        (
          astNode.getNumParameter() = 4
          implies
          getRouteHandlerParameter(astNode, "error").getName() = error
        ) and
        not (
          // heuristic: max four parameters (the server will only supply four arguments)
          astNode.getNumParameter() > 4
          or
          // heuristic: not a class method (the server invokes this with a function call)
          astNode = any(MethodDefinition def).getBody()
          or
          // heuristic: does not return anything (the server will not use the return value)
          exists(astNode.getAReturnStmt().getExpr())
          or
          // heuristic: is not invoked (the server invokes this at a call site we cannot reason precisely about)
          exists(DataFlow::InvokeNode cs | cs.getACallee() = astNode)
        )
      )
    }
  }
}
