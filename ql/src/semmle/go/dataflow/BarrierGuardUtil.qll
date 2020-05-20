/**
 * Contains implementations of some commonly used barrier
 * guards for sanitizing untrusted URLs.
 */

import go

/**
 * A call to a function called `isLocalUrl`, `isValidRedirect`, or similar, which is
 * considered a barrier guard for sanitizing untrusted URLs.
 */
class RedirectCheckBarrierGuard extends DataFlow::BarrierGuard, DataFlow::CallNode {
  RedirectCheckBarrierGuard() {
    this.getCalleeName().regexpMatch("(?i)(is_?)?(local_?url|valid_?redir(ect)?)")
  }

  override predicate checks(Expr e, boolean outcome) {
    // `isLocalUrl(e)` is a barrier for `e` if it evaluates to `true`
    getAnArgument().asExpr() = e and
    outcome = true
  }
}

/**
 * An equality check comparing a data-flow node against a constant string, considered as
 * a barrier guard for sanitizing untrusted URLs.
 *
 * Additionally, a check comparing `url.Hostname()` against a constant string is also
 * considered a barrier guard for `url`.
 */
class UrlCheck extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
  DataFlow::Node url;

  UrlCheck() {
    exists(this.getAnOperand().getStringValue()) and
    (
      url = this.getAnOperand()
      or
      exists(DataFlow::MethodCallNode mc | mc = this.getAnOperand() |
        mc.getTarget().getName() = "Hostname" and
        url = mc.getReceiver()
      )
    )
  }

  override predicate checks(Expr e, boolean outcome) {
    e = url.asExpr() and outcome = this.getPolarity()
  }
}

/**
 * A call to a regexp match function, considered as a barrier guard for sanitizing untrusted URLs.
 *
 * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
 */
class RegexpCheck extends DataFlow::BarrierGuard {
  RegexpMatchFunction matchfn;
  DataFlow::CallNode call;

  RegexpCheck() {
    matchfn.getACall() = call and
    this = matchfn.getResult().getNode(call).getASuccessor*()
  }

  override predicate checks(Expr e, boolean branch) {
    e = matchfn.getValue().getNode(call).asExpr() and
    (branch = false or branch = true)
  }
}
