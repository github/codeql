/**
 * @name Operator Find Incorrectly Used Exceptions
 * @description --Finding for places of incomplete use of objects, type exception.
 * @kind problem
 * @id cpp/operator-find-incorrectly-used-exceptions
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-703
 *       external/cwe/cwe-248
 *       external/cwe/cwe-390
 */

import cpp

from FunctionCall fc, string msg
where
  exists(ThrowExpr texp |
    texp.getEnclosingFunction() = fc.getTarget() and
    not exists(TryStmt ts |
      texp.getEnclosingStmt().getParentStmt*() = ts.getStmt() and
      not ts.getACatchClause().isEmpty()
    ) and
    msg = "Exception inside this function requires more handling."
  )
  or
  fc.getTarget() instanceof Constructor and
  fc.getTargetType().(Class).getABaseClass+().hasGlobalOrStdName("exception") and
  not fc.isInMacroExpansion() and
  not exists(ThrowExpr texp | fc.getEnclosingStmt() = texp.getEnclosingStmt()) and
  not exists(FunctionCall fctmp | fctmp.getAnArgument() = fc) and
  not fc instanceof ConstructorDirectInit and
  not fc.getEnclosingStmt() instanceof DeclStmt and
  not fc instanceof ConstructorDelegationInit and
  msg = "This object does not generate an exception."
select fc, msg
