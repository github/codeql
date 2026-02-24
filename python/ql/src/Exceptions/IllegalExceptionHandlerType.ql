/**
 * @name Non-exception in 'except' clause
 * @description An exception handler specifying a non-exception type will never handle any exception.
 * @kind problem
 * @tags quality
 *       reliability
 *       error-handling
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/useless-except
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
private import ExceptionTypes

/**
 * Gets an expression used as a handler type in the `except` clause at `ex`,
 * either directly or as an element of a tuple.
 */
Expr handlerExpr(ExceptStmt ex) {
  result = ex.getType() or
  result = ex.getType().(Tuple).getAnElt()
}

/**
 * Gets an exception type used in the `except` clause at `ex`,
 * where that type is not a legal exception type.
 */
ExceptType illegalHandlerType(ExceptStmt ex) {
  result.getAUse().asExpr() = handlerExpr(ex) and
  not result.isLegalExceptionType()
}

from ExceptStmt ex, string msg
where
  exists(ExceptType t | t = illegalHandlerType(ex) |
    msg =
      "Non-exception class '" + t.getName() +
        "' in exception handler which will never match raised exception."
  )
  or
  exists(ImmutableLiteral lit | lit = handlerExpr(ex) and not lit instanceof None |
    msg =
      "Non-exception class '" + DuckTyping::getClassName(lit) +
        "' in exception handler which will never match raised exception."
  )
select ex, msg
