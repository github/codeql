/**
 * @name Using the return value of a strcpy or related string copy function in an if statement
 * @description The return value for strcpy or related string copy functions have no reserved return value to indicate an error.
 *              Using these functions as part of an if statement condition indicates a logic error.
 *              Either the intent was to use a more secure version of a string copy function (such as strcpy_s), 
 *              or a string compare function (such as strcmp).
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/string-copy-function-in-if-condition
 * @tags external/microsoft/C6324
 */

import cpp

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

from IfStmt ifs,  
FunctionCall func
where isStringComparisonFunction( func.getTarget().getQualifiedName() )
  and ( func = ifs.getCondition() 
    or exists( UnaryLogicalOperation ule |
      ule = ifs.getCondition()
      and func = ule.getAChild()
    )
    or exists( BinaryLogicalOperation ble |
      ble = ifs.getCondition()
      and func = ble.getAChild()
    )
    or exists( EqualityOperation eop |
      eop = ifs.getCondition()
      and func = eop.getAChild()
    )
  )
select func, "Incorrect use of function " + func.getTarget().getQualifiedName() + ". Verify the logic and replace with a secure string copy function, or a string comparison function."
