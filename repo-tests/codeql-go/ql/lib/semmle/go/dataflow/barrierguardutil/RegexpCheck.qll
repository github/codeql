/**
 * Provides an implementation of a commonly used barrier guard for sanitizing untrusted URLs.
 */

import go

/**
 * A call to a regexp match function, considered as a barrier guard for sanitizing untrusted URLs.
 *
 * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
 *
 * Use this if you want to define a derived `DataFlow::BarrierGuard` without
 * make the type recursive. Otherwise use `RegexpCheck`.
 */
predicate regexpFunctionChecksExpr(DataFlow::Node resultNode, Expr checked, boolean branch) {
  exists(RegexpMatchFunction matchfn, DataFlow::CallNode call |
    matchfn.getACall() = call and
    resultNode = matchfn.getResult().getNode(call).getASuccessor*() and
    checked = matchfn.getValue().getNode(call).asExpr() and
    (branch = false or branch = true)
  )
}

/**
 * A call to a regexp match function, considered as a barrier guard for sanitizing untrusted URLs.
 *
 * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
 */
class RegexpCheck extends DataFlow::BarrierGuard {
  RegexpCheck() { regexpFunctionChecksExpr(this, _, _) }

  override predicate checks(Expr e, boolean branch) { regexpFunctionChecksExpr(this, e, branch) }
}
