/**
 * Provides an implementation of a commonly used barrier guard for sanitizing untrusted URLs.
 */

import go

/**
 * A call to a function called `isLocalUrl`, `isValidRedirect`, or similar, which is
 * considered a barrier guard for sanitizing untrusted URLs.
 */
class RedirectCheckBarrierGuard extends DataFlow::BarrierGuard, DataFlow::CallNode {
  RedirectCheckBarrierGuard() {
    this.getCalleeName().regexpMatch("(?i)(is_?)?(local_?url|valid_?redir(ect)?)(ur[li])?")
  }

  override predicate checks(Expr e, boolean outcome) {
    // `isLocalUrl(e)` is a barrier for `e` if it evaluates to `true`
    this.getAnArgument().asExpr() = e and
    outcome = true
  }
}
