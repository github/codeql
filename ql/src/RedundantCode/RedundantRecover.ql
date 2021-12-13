/**
 * @name Redundant call to recover
 * @description Calling 'recover' in a function which isn't called using a defer
 *              statement has no effect. Also, putting 'recover' directly in a
 *              defer statement has no effect.
 * @kind problem
 * @problem.severity warning
 * @id go/redundant-recover
 * @tags maintainability
 *       correctness
 * @precision high
 */

import go

predicate isDeferred(DataFlow::CallNode call) {
  exists(DeferStmt defer | defer.getCall() = call.asExpr())
}

from DataFlow::CallNode recoverCall, FuncDef f, string msg
where
  recoverCall.getTarget() = Builtin::recover() and
  f = recoverCall.getRoot() and
  (
    isDeferred(recoverCall) and
    msg = "Deferred calls to 'recover' have no effect."
    or
    not isDeferred(recoverCall) and
    exists(f.getACall()) and
    not isDeferred(f.getACall()) and
    msg = "This call to 'recover' has no effect because $@ is never called using a defer statement."
  )
select recoverCall, msg, f, "the enclosing function"
