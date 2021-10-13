/**
 * @name Ignored return value
 * @description Ignoring return values may result in discarding errors or loss of information.
 * @kind problem
 * @tags reliability
 *       readability
 *       convention
 *       statistical
 *       non-attributable
 *       external/cwe/cwe-252
 * @problem.severity recommendation
 * @sub-severity high
 * @precision medium
 * @id py/ignored-return-value
 */

import python
import semmle.python.objects.Callables

predicate meaningful_return_value(Expr val) {
  val instanceof Name
  or
  val instanceof BooleanLiteral
  or
  exists(FunctionValue callee |
    val = callee.getACall().getNode() and returns_meaningful_value(callee)
  )
  or
  not exists(FunctionValue callee | val = callee.getACall().getNode()) and not val instanceof Name
}

/* Value is used before returning, and thus its value is not lost if ignored */
predicate used_value(Expr val) {
  exists(LocalVariable var, Expr other |
    var.getAnAccess() = val and other = var.getAnAccess() and not other = val
  )
}

predicate returns_meaningful_value(FunctionValue f) {
  not exists(f.getScope().getFallthroughNode()) and
  (
    exists(Return ret, Expr val | ret.getScope() = f.getScope() and val = ret.getValue() |
      meaningful_return_value(val) and
      not used_value(val)
    )
    or
    /*
     * Is f a builtin function that returns something other than None?
     * Ignore __import__ as it is often called purely for side effects
     */

    f.isBuiltin() and
    f.getAnInferredReturnType() != ClassValue::nonetype() and
    not f.getName() = "__import__"
  )
}

/* If a call is wrapped tightly in a try-except then we assume it is being executed for the exception. */
predicate wrapped_in_try_except(ExprStmt call) {
  exists(Try t |
    exists(t.getAHandler()) and
    strictcount(Call c | t.getBody().contains(c)) = 1 and
    call = t.getAStmt()
  )
}

from ExprStmt call, FunctionValue callee, float percentage_used, int total
where
  call.getValue() = callee.getACall().getNode() and
  returns_meaningful_value(callee) and
  not wrapped_in_try_except(call) and
  exists(int unused |
    unused = count(ExprStmt e | e.getValue().getAFlowNode() = callee.getACall()) and
    total = count(callee.getACall())
  |
    percentage_used = (100.0 * (total - unused) / total).floor()
  ) and
  /* Report an alert if we see at least 5 calls and the return value is used in at least 3/4 of those calls. */
  percentage_used >= 75 and
  total >= 5
select call,
  "Call discards return value of function $@. The result is used in " + percentage_used.toString() +
    "% of calls.", callee, callee.getName()
