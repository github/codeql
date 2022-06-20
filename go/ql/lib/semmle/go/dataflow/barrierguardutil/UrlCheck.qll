/**
 * Provides an implementation of a commonly used barrier guard for sanitizing untrusted URLs.
 */

import go

private predicate urlCheck(DataFlow::Node g, Expr e, boolean outcome) {
  exists(DataFlow::Node url, DataFlow::EqualityTestNode eq |
    g = eq and
    exists(eq.getAnOperand().getStringValue()) and
    (
      url = eq.getAnOperand()
      or
      exists(DataFlow::MethodCallNode mc | mc = eq.getAnOperand() |
        mc.getTarget().getName() = "Hostname" and
        url = mc.getReceiver()
      )
    ) and
    e = url.asExpr() and
    outcome = eq.getPolarity()
  )
}

/**
 * An equality check comparing a data-flow node against a constant string, considered as
 * a barrier guard for sanitizing untrusted URLs.
 *
 * Additionally, a check comparing `url.Hostname()` against a constant string is also
 * considered a barrier guard for `url`.
 */
class UrlCheckBarrier extends DataFlow::Node {
  UrlCheckBarrier() { this = DataFlow::BarrierGuard<urlCheck/3>::getABarrierNode() }
}

/**
 * DEPRECATED: Use `UrlCheckBarrier` instead.
 *
 * An equality check comparing a data-flow node against a constant string, considered as
 * a barrier guard for sanitizing untrusted URLs.
 *
 * Additionally, a check comparing `url.Hostname()` against a constant string is also
 * considered a barrier guard for `url`.
 */
deprecated class UrlCheck extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
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
