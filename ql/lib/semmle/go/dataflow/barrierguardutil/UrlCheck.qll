/**
 * Provides an implementation of a commonly used barrier guard for sanitizing untrusted URLs.
 */

import go

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
