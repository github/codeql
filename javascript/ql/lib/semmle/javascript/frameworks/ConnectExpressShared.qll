/**
 * Provides classes for working with the shared interfaces of
 * [Connect](https://github.com/senchalabs/connect) and
 * [Express](https://expressjs.com) applications.
 */

import javascript

module ConnectExpressShared {
  /**
   * String representing the signature of a route handler, that is,
   * the list of parameters taken by the route handler.
   *
   * Concretely this is a comma-separated list of parameter kinds, which can be either
   * `request`, `response`, `next`, `error`, or `parameter`, but this is considered an
   * implementation detail.
   */
  private class RouteHandlerSignature extends string {
    RouteHandlerSignature() {
      this =
        [
          "request,response", "request,response,next", "request,response,next,parameter",
          "error,request,response,next"
        ]
    }

    /** Gets the index of the parameter corresonding to the given `kind`, if any. */
    pragma[noinline]
    int getParameterIndex(string kind) { this.splitAt(",", result) = kind }

    /** Gets the number of parameters taken by this signature. */
    pragma[noinline]
    int getArity() { result = count(this.getParameterIndex(_)) }

    /** Holds if this signature takes a parameter of the given kind. */
    predicate has(string kind) { exists(this.getParameterIndex(kind)) }
  }

  private module RouteHandlerSignature {
    /** Gets the signature corresonding to `(req, res, next, param) => {...}`. */
    RouteHandlerSignature requestResponseNextParameter() {
      result = "request,response,next,parameter"
    }

    /** Gets the signature corresonding to `(req, res, next) => {...}`. */
    RouteHandlerSignature requestResponseNext() { result = "request,response,next" }

    /** Gets the signature corresonding to `(err, req, res, next) => {...}`. */
    RouteHandlerSignature errorRequestResponseNext() { result = "error,request,response,next" }
  }

  /**
   * Holds if `fun` appears to match the given signature based on parameter naming.
   */
  private predicate matchesSignature(Function function, RouteHandlerSignature sig) {
    function.getNumParameter() = sig.getArity() and
    function.getParameter(sig.getParameterIndex("request")).getName() = ["req", "request"] and
    function.getParameter(sig.getParameterIndex("response")).getName() = ["res", "response"] and
    (
      sig.has("next")
      implies
      function.getParameter(sig.getParameterIndex("next")).getName() = ["next", "cb"]
    )
  }

  /**
   * Gets the parameter corresonding to the given `kind`, where `routeHandler` is interpreted as a
   * route handler with the signature `sig`.
   *
   * This does not check if the function is actually a route handler or matches the signature in any way,
   * so the caller should restrict the function accordingly.
   */
  pragma[inline]
  private Parameter getRouteHandlerParameter(
    Function routeHandler, RouteHandlerSignature sig, string kind
  ) {
    result = routeHandler.getParameter(sig.getParameterIndex(kind))
  }

  /**
   * Gets the parameter of kind `kind` of a Connect/Express route parameter handler function.
   *
   * `kind` is one of: "error", "request", "response", "next".
   */
  pragma[inline]
  Parameter getRouteParameterHandlerParameter(Function routeHandler, string kind) {
    result =
      getRouteHandlerParameter(routeHandler, RouteHandlerSignature::requestResponseNextParameter(),
        kind)
  }

  /**
   * Gets the parameter of kind `kind` of a Connect/Express route handler function.
   *
   * `kind` is one of: "error", "request", "response", "next".
   */
  pragma[inline]
  Parameter getRouteHandlerParameter(Function routeHandler, string kind) {
    if routeHandler.getNumParameter() = 4
    then
      // For arity 4 there is ambiguity between (err, req, res, next) and (req, res, next, param)
      // This predicate favors the 'err' signature whereas getRouteParameterHandlerParameter favors the other.
      result =
        getRouteHandlerParameter(routeHandler, RouteHandlerSignature::errorRequestResponseNext(),
          kind)
    else
      result =
        getRouteHandlerParameter(routeHandler, RouteHandlerSignature::requestResponseNext(), kind)
  }

  /**
   * A function that looks like a Connect/Express route handler.
   *
   * For example, this could be the function `function(req, res, next){...}`.
   */
  class RouteHandlerCandidate extends HTTP::RouteHandlerCandidate {
    RouteHandlerCandidate() {
      matchesSignature(astNode, _) and
      not (
        // heuristic: not a class method (the server invokes this with a function call)
        astNode = any(MethodDefinition def).getBody()
        or
        // heuristic: does not return anything (the server will not use the return value)
        exists(astNode.getAReturnStmt().getExpr())
        or
        // heuristic: is not invoked (the server invokes this at a call site we cannot reason precisely about)
        exists(DataFlow::InvokeNode cs | cs.getACallee() = astNode)
      )
    }
  }
}
