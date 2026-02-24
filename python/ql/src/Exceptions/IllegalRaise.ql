/**
 * @name Illegal raise
 * @description Raising a non-exception object or type will result in a TypeError being raised instead.
 * @kind problem
 * @tags quality
 *       reliability
 *       error-handling
 * @problem.severity error
 * @sub-severity high
 * @precision very-high
 * @id py/illegal-raise
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
import semmle.python.ApiGraphs
private import ExceptionTypes

/**
 * Holds if `r` raises an instance of a builtin non-exception class named `name`.
 */
private predicate raisesNonExceptionBuiltin(Raise r, string name) {
  exists(Expr raised | raised = r.getRaised() |
    API::builtin(name).getAValueReachableFromSource().asExpr() = raised
    or
    API::builtin(name).getAValueReachableFromSource().asExpr() = raised.(Call).getFunc() and
    // Exclude `type` since `type(x)` returns the class of `x`, not a `type` instance
    not name = "type"
  ) and
  not builtinException(name)
}

from Raise r, string msg
where
  not raisesNonExceptionBuiltin(r, "NotImplemented") and
  (
    exists(ExceptType t |
      t.isRaisedBy(r) and
      not t.isLegalExceptionType() and
      not t.getName() = "None" and
      msg =
        "Illegal class '" + t.getName() +
          "' raised; will result in a TypeError being raised instead."
    )
    or
    exists(ImmutableLiteral lit | lit = r.getRaised() |
      msg =
        "Illegal class '" + DuckTyping::getClassName(lit) +
          "' raised; will result in a TypeError being raised instead."
    )
    or
    exists(string name |
      raisesNonExceptionBuiltin(r, name) and
      not r.getRaised() instanceof ImmutableLiteral and
      not name = "None" and
      msg = "Illegal class '" + name + "' raised; will result in a TypeError being raised instead."
    )
  )
select r, msg
