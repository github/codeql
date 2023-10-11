/**
 * Provides an implementation of a commonly used barrier guard for sanitizing untrusted URLs.
 */

import go

private predicate redirectCheckGuard(DataFlow::Node g, Expr e, boolean outcome) {
  g.(DataFlow::CallNode)
      .getCalleeName()
      .regexpMatch("(?i)(is_?)?(local_?url|valid_?redir(ect)?)(ur[li])?") and
  // `isLocalUrl(e)` is a barrier for `e` if it evaluates to `true`
  g.(DataFlow::CallNode).getAnArgument().asExpr() = e and
  outcome = true
}

/**
 * A call to a function called `isLocalUrl`, `isValidRedirect`, or similar, which is
 * considered a barrier guard for sanitizing untrusted URLs.
 */
class RedirectCheckBarrier extends DataFlow::Node {
  RedirectCheckBarrier() { this = DataFlow::BarrierGuard<redirectCheckGuard/3>::getABarrierNode() }
}
