/**
 * @name Use of string copy function in a condition
 * @description The return value for strcpy, strncpy, or related string copy
 *              functions have no reserved return value to indicate an error.
 *              Using them in a condition is likely to be a logic error.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/string-copy-return-value-as-boolean
 * @tags external/microsoft/C6324
 *       correctness
 */

import cpp
import semmle.code.cpp.models.implementations.Strcpy
import semmle.code.cpp.dataflow.DataFlow

/**
 * A string copy function that returns a string, rather than an error code (for
 * example, `strcpy` returns a string, whereas `strcpy_s` returns an error
 * code).
 */
class InterestingStrcpyFunction extends StrcpyFunction {
  InterestingStrcpyFunction() { getType().getUnspecifiedType() instanceof PointerType }
}

predicate isBoolean(Expr e1) {
  exists(Type t1 |
    t1 = e1.getType() and
    (t1.hasName("bool") or t1.hasName("BOOL") or t1.hasName("_Bool"))
  )
}

predicate isStringCopyCastedAsBoolean(FunctionCall func, Expr expr1, string msg) {
  DataFlow::localExprFlow(func, expr1) and
  isBoolean(expr1.getConversion*()) and
  func.getTarget() instanceof InterestingStrcpyFunction and
  msg = "Return value of " + func.getTarget().getName() + " used as a Boolean."
}

predicate isStringCopyUsedInLogicalOperationOrCondition(FunctionCall func, Expr expr1, string msg) {
  func.getTarget() instanceof InterestingStrcpyFunction and
  (
    (
      // it is being used in an equality or logical operation
      exists(EqualityOperation eop |
        eop = expr1 and
        func = eop.getAnOperand()
      )
      or
      exists(UnaryLogicalOperation ule |
        expr1 = ule and
        func = ule.getOperand()
      )
      or
      exists(BinaryLogicalOperation ble |
        expr1 = ble and
        func = ble.getAnOperand()
      )
    ) and
    msg = "Return value of " + func.getTarget().getName() + " used in a logical operation."
    or
    // or the string copy function is used directly as the conditional expression
    (
      exists(ConditionalStmt condstmt |
        func = condstmt.getControllingExpr() and
        expr1 = func
      )
      or
      exists(ConditionalExpr ce |
        expr1 = ce and
        func = ce.getCondition()
      )
    ) and
    msg =
      "Return value of " + func.getTarget().getName() +
        " used directly in a conditional expression."
  )
}

from FunctionCall func, Expr expr1, string msg
where
  isStringCopyCastedAsBoolean(func, expr1, msg) and
  not isStringCopyUsedInLogicalOperationOrCondition(func, _, _)
  or
  isStringCopyUsedInLogicalOperationOrCondition(func, expr1, msg)
select expr1, msg
