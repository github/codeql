/**
 * @id cpp/microsoft/public/sizeof/sizeof-or-operation-as-argument
 * @name Usage of an expression that is a binary operation, or sizeof call passed as an argument to a sizeof call
 * @description When the `expr` passed to `sizeof` is a binary operation, or a sizeof call, this is typically a sign that there is a confusion on the usage of sizeof.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp
import SizeOfTypeUtils

from CandidateSizeofCall sizeofExpr, string message, Expr op
where
  exists(string tmpMsg |
    (
      op instanceof BinaryOperation and tmpMsg = "binary operator"
      or
      op instanceof SizeofOperator and tmpMsg = "sizeof"
    ) and
    if sizeofExpr.isInMacroExpansion()
    then message = tmpMsg + "(in a macro expansion)"
    else message = tmpMsg
  ) and
  op = sizeofExpr.getExprOperand()
select sizeofExpr, "$@: $@ of $@ inside sizeof.", sizeofExpr, message,
  sizeofExpr.getEnclosingFunction(), "Usage", op, message
