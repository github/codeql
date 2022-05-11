/**
 * @name Failure to abandon session
 * @description Reusing an existing session as a different user could allow
 *              an attacker to access someone else's account by using
 *              their session.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5
 * @precision medium
 * @id js/session-fixation
 * @tags security
 *       external/cwe/cwe-384
 */

import javascript

/**
 * Holds if `setup` uses express-session (or similar) to log in a user.
 */
pragma[inline]
predicate isLoginSetup(Express::RouteSetup setup) {
  // either some path that contains "login" with a write to `req.session`
  setup.getPath().matches("%login%") and
  exists(
    setup
        .getARouteHandler()
        .(Express::RouteHandler)
        .getARequestSource()
        .ref()
        .getAPropertyRead("session")
        .getAPropertyWrite()
  )
  or
  // or an authentication method is used (e.g. `passport.authenticate`)
  setup.getARouteHandler().(DataFlow::CallNode).getCalleeName() = "authenticate"
}

/**
 * Holds if `handler` regenerates its session using `req.session.regenerate`.
 */
pragma[inline]
predicate regeneratesSession(Express::RouteSetup setup) {
  exists(
    setup
        .getARouteHandler()
        .(Express::RouteHandler)
        .getARequestSource()
        .ref()
        .getAPropertyRead("session")
        .getAPropertyRead("regenerate")
  )
}

from Express::RouteSetup setup
where
  isLoginSetup(setup) and
  not regeneratesSession(setup)
select setup, "Route handler does not invalidate session following login"
