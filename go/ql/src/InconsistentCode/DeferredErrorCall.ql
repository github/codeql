/**
 * @name Deferred call may return an error
 * @description Deferring a call to a function which may return an error means that an error may not be handled.
 * @kind problem
 * @problem.severity warning
 * @id go/deferred-error-call
 * @tags maintainability
 *  correctness
 *  call
 *  defer
 */

import go

string getFunctionName(CallExpr call) {
  if exists(call.getCalleeName())
  then result = call.getCalleeName()
  else result = "an anonymous function"
}

from DeferStmt defer, SignatureType sig
where
  // match all deferred function calls and obtain their type signatures
  sig = defer.getCall().getCalleeExpr().getType() and
  // check that one of the results is an error
  sig.getResultType(_).implements(Builtin::error().getType().getUnderlyingType())
select defer, "Deferred a call to $@, which may return an error.", defer.getCall().getCalleeExpr(),
  getFunctionName(defer.getCall())
