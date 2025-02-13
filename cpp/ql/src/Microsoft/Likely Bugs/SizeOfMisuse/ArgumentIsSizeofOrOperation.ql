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

/**
 * Windows SDK corecrt_math.h defines a macro _CLASS_ARG that
 * intentionally misuses sizeof to determine the size of a floating point type.
 * Explicitly ignoring any hit in this macro.
 */
predicate isPartOfCrtFloatingPointMacroExpansion(Expr e) {
  exists(MacroInvocation mi |
    mi.getMacroName() = "_CLASS_ARG" and
    mi.getMacro().getFile().getBaseName() = "corecrt_math.h" and
    mi.getAnExpandedElement() = e
  )
}

/**
 * Determines if the sizeOfExpr is ignorable.
 */
predicate ignorableSizeof(SizeofExprOperator sizeofExpr) {
  // a common pattern found is to sizeof a binary operation to check a type
  // to then perfomr an onperaiton for a 32 or 64 bit type.
  // these cases often look like sizeof(x) >=4
  // more generally we see binary operations frequently used in different type
  // checks, where the sizeof is part of some comparison operation of a switch statement guard.
  // sizeof as an argument is also similarly used, but seemingly less frequently.
  exists(ComparisonOperation comp | comp.getAnOperand() = sizeofExpr)
  or
  exists(ConditionalStmt s | s.getControllingExpr() = sizeofExpr)
  or
  // another common practice is to use bit-wise operations in sizeof to allow the compiler to
  // 'pack' the size appropriate but get the size of the result out of a sizeof operation.
  sizeofExpr.getExprOperand() instanceof BinaryBitwiseOperation
}

from SizeofExprOperator sizeofExpr, string message, Expr op
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
  op = sizeofExpr.getExprOperand() and
  not isPartOfCrtFloatingPointMacroExpansion(op) and
  not ignorableSizeof(sizeofExpr)
select sizeofExpr, "$@: $@ of $@ inside sizeof.", sizeofExpr, message,
  sizeofExpr.getEnclosingFunction(), "Usage", op, message
