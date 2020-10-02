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

/** Gets a property name of `req` which refers to data usually derived from cookie data. */
string cookieProperty() { result = "session" or result = "cookies" or result = "user" }

/** Gets a data flow node that flows to the base of an access to `cookies`, `session`, or `user`. */
private DataFlow::SourceNode nodeLeadingToCookieAccess(DataFlow::TypeBackTracker t) {
  t.start() and
  exists(DataFlow::PropRef value |
    value = result.getAPropertyRead(cookieProperty()).getAPropertyReference() and
    // Ignore accesses to values that are part of a CSRF or captcha check
    not value.getPropertyName().regexpMatch("(?i).*(csrf|xsrf|captcha).*") and
    // Ignore calls like `req.session.save()`
    not value = any(DataFlow::InvokeNode call).getCalleeNode()
  )
  or
  exists(DataFlow::TypeBackTracker t2 | result = nodeLeadingToCookieAccess(t2).backtrack(t2, t))
}

/** Gets a data flow node that flows to the base of an access to `cookies`, `session`, or `user`. */
DataFlow::SourceNode nodeLeadingToCookieAccess() {
  result = nodeLeadingToCookieAccess(DataFlow::TypeBackTracker::end())
}

/**
 * Holds if `handler` uses cookies.
 */
predicate isRouteHandlerUsingCookies(Express::RouteHandler handler) {
  DataFlow::parameterNode(handler.getRequestParameter()) = nodeLeadingToCookieAccess()
}

/** Gets a data flow node referring to a route handler that uses cookies. */
private DataFlow::SourceNode getARouteUsingCookies(DataFlow::TypeTracker t) {
  t.start() and
  isRouteHandlerUsingCookies(result)
  or
  exists(DataFlow::TypeTracker t2, DataFlow::SourceNode pred | pred = getARouteUsingCookies(t2) |
    result = pred.track(t2, t)
    or
    t = t2 and
    HTTP::routeHandlerStep(pred, result)
  )
}

/** Gets a data flow node referring to a route handler that uses cookies. */
DataFlow::SourceNode getARouteUsingCookies() {
  result = getARouteUsingCookies(DataFlow::TypeTracker::end())
}

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
  // Require that the handler uses cookies and has cookie middleware.
  //
  // In practice, handlers that use cookies always have the cookie middleware or
  // the handler wouldn't work. However, if we can't find the cookie middleware, it
  // indicates that our middleware model is too incomplete, so in that case we
  // don't trust it to detect the presence of CSRF middleware either.
  getARouteUsingCookies().flowsToExpr(handler) and
  hasCookieMiddleware(handler, cookie) and
  // Only flag the cookie parser registered first.
  not hasCookieMiddleware(cookie, _) and
  not hasCsrfMiddleware(handler) and
  // Only warn for the last handler in a chain.
  handler.isLastHandler() and
  // Only warn for dangerous handlers, such as for POST and PUT.
  not setup.getRequestMethod().isSafe()
select cookie, "This cookie middleware is serving a request handler $@ without CSRF protection.",
  handler, "here"
