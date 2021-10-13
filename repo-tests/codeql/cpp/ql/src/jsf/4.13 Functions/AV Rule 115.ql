/**
 * @name AV Rule 115
 * @description If a function returns error information, then that
 *              information will be tested.
 * @kind problem
 * @id cpp/jsf/av-rule-115
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

// a return statement that looks like it returns an error code
// we use an extremely simple approximation: any return statement that returns
// a literal or a symbolic constant is considered to return an error code; we
// make an exception for integral constant zero, which often indicates success
// (unlike, of course, the null pointer)
class ErrorReturn extends ReturnStmt {
  ErrorReturn() {
    exists(Expr e |
      e = super.getExpr() and
      (
        e instanceof Literal or
        e.(VariableAccess).getTarget().isConst()
      ) and
      not (e.getValue() = "0" and e.getActualType() instanceof IntegralType)
    )
  }
}

// a function that has both a return statement returning an error code, and one that doesn't
class FunctionReturningErrorCode extends Function {
  FunctionReturningErrorCode() {
    exists(ErrorReturn er, ReturnStmt nr |
      er.getEnclosingFunction() = this and
      nr.getEnclosingFunction() = this and
      not nr instanceof ErrorReturn
    )
  }
}

from FunctionReturningErrorCode frec, Call c
where
  c = frec.getACallToThisFunction() and
  c instanceof ExprInVoidContext
select c, "AV Rule 115: If a function returns error information, it will be tested."
