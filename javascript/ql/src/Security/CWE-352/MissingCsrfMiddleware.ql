/**
 * @name Missing CSRF middleware
 * @description Using cookies without CSRF protection may allow malicious websites to
 *              submit requests on behalf of the user.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/missing-token-validation
 * @tags security
 *       external/cwe/cwe-352
 */

import javascript

/**
 * Checks if `expr` is preceded by the cookie middleware `cookie`.
 *
 * A router handler following after cookie parsing is assumed to depend on
 * cookies, and thus require CSRF protection.
 */
predicate hasCookieMiddleware(Express::RouteHandlerExpr expr, Express::RouteHandlerExpr cookie) {
  any(HTTP::CookieMiddlewareInstance i).flowsToExpr(cookie) and
  expr.getAMatchingAncestor() = cookie
}

/**
 * Gets an expression that creates a route handler which protects against CSRF attacks.
 *
 * Any route handler registered downstream from this type of route handler will
 * be considered protected.
 *
 * For example:
 * ```
 * let csurf = require('csurf');
 * let csrfProtector = csurf();
 *
 * app.post('/changePassword', csrfProtector, function (req, res) {
 *   // protected from CSRF
 * })
 * ```
 */
DataFlow::CallNode csrfMiddlewareCreation() {
  exists(DataFlow::SourceNode callee | result = callee.getACall() |
    callee = DataFlow::moduleImport("csurf")
    or
    callee = DataFlow::moduleImport("lusca") and
    exists(result.getOptionArgument(0, "csrf"))
    or
    callee = DataFlow::moduleMember("lusca", "csrf")
  )
}

/**
 * Holds if the given route handler is protected by CSRF middleware.
 */
predicate hasCsrfMiddleware(Express::RouteHandlerExpr handler) {
  csrfMiddlewareCreation().flowsToExpr(handler.getAMatchingAncestor())
}

from
  Express::RouterDefinition router, Express::RouteSetup setup, Express::RouteHandlerExpr handler,
  Express::RouteHandlerExpr cookie
where
  router = setup.getRouter() and
  handler = setup.getARouteHandlerExpr() and
  hasCookieMiddleware(handler, cookie) and
  not hasCsrfMiddleware(handler) and
  // Only warn for the last handler in a chain.
  handler.isLastHandler() and
  // Only warn for dangerous for handlers, such as for POST and PUT.
  not setup.getRequestMethod().isSafe()
select cookie, "This cookie middleware is serving a request handler $@ without CSRF protection.",
  handler, "here"
