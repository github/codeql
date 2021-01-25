/**
 * Provides an implementation of a commonly used barrier guard for sanitizing untrusted URLs.
 */

import go

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
