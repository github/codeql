/**
 * @name Using the return value of a strcpy or related string copy function as a boolean operator
 * @description The return value for strcpy, strncpy, or related string copy functions have no reserved return value to indicate an error.
 *              Using the return values of these functions as boolean function .
 *              Either the intent was to use a more secure version of a string copy function (such as strcpy_s), or a string compare function (such as strcmp).
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/string-copy-return-value-as-boolean
 * @tags external/microsoft/C6324
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow

predicate isStringComparisonFunction(string functionName) {
  functionName = "strcpy"
  or functionName = "wcscpy"
  or functionName = "_mbscpy"
  or functionName = "strncpy"
  or functionName = "_strncpy_l"
  or functionName = "wcsncpy"
  or functionName = "_wcsncpy_l"
  or functionName = "_mbsncpy"
  or functionName = "_mbsncpy_l"
}

predicate isBoolean( Expr e1 )
{
  exists ( Type t1 |
    t1 = e1.getType() and
    (t1.hasName("bool") or t1.hasName("BOOL") or t1.hasName("_Bool"))
  )
}

predicate isStringCopyCastedAsBoolean( FunctionCall func, Expr expr1, string msg ) {
  DataFlow::localFlow(DataFlow::exprNode(func), DataFlow::exprNode(expr1))
  and isBoolean( expr1.getConversion*())
  and isStringComparisonFunction( func.getTarget().getQualifiedName())
  and msg = "Return Value of " + func.getTarget().getQualifiedName() + " used as boolean."
}

predicate isStringCopyUsedInLogicalOperationOrCondition( FunctionCall func, Expr expr1, string msg ) {
    isStringComparisonFunction( func.getTarget().getQualifiedName() )
    and ((( 
      // it is being used in an equality or logical operation 
      exists( EqualityOperation eop |
        eop = expr1
        and func = eop.getAChild()
      )
      or exists( UnaryLogicalOperation ule |
        expr1 = ule
        and func = ule.getAChild()
      )
      or exists( BinaryLogicalOperation ble |
        expr1 = ble
        and func = ble.getAChild()
      )
    )
    and msg = "Return Value of " + func.getTarget().getQualifiedName() + " used in a logical operation."
    )
    or
      exists( ConditionalStmt condstmt |
      condstmt.getAChild() = expr1 |
      // or the string copy function is used directly as the conditional expression
      func = condstmt.getChild(0)
      and msg = "Return Value of " + func.getTarget().getQualifiedName() + " used directly in a conditional expression."
    ))
}

from FunctionCall func, Expr expr1, string msg
where 
  ( isStringCopyCastedAsBoolean(func, expr1, msg) and 
    not isStringCopyUsedInLogicalOperationOrCondition(func, expr1, _)
  )
  or isStringCopyUsedInLogicalOperationOrCondition(func, expr1, msg)
select expr1, msg
