/**
 * @name Dangerous use of transformation after operation.
 * @description By using the transformation after the operation, you are doing a pointless and dangerous action.
 * @kind problem
 * @id cpp/dangerous-use-of-transformation-after-operation
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-190
 */

import cpp

/** Returns the number of the expression in the function call arguments. */
int argumentPosition(FunctionCall fc, Expr exp, int n) {
  n in [0 .. fc.getNumberOfArguments() - 1] and
  fc.getArgument(n) = exp and
  result = n
}

/** Holds if a nonsensical type conversion situation is found. */
predicate conversionDoneLate(MulExpr mexp) {
  exists(Expr e1, Expr e2 |
    mexp.hasOperands(e1, e2) and
    not e1.isConstant() and
    not e1.hasConversion() and
    not e1.hasConversion() and
    (
      e2.isConstant() or
      not e2.hasConversion()
    ) and
    mexp.getConversion().hasExplicitConversion() and
    mexp.getConversion() instanceof ParenthesisExpr and
    mexp.getConversion().getConversion() instanceof CStyleCast and
    mexp.getConversion().getConversion().getType().getSize() > mexp.getType().getSize() and
    mexp.getConversion().getConversion().getType().getSize() > e2.getType().getSize() and
    mexp.getConversion().getConversion().getType().getSize() > e1.getType().getSize() and
    exists(Expr e0 |
      e0.(AssignExpr).getRValue() = mexp.getParent*() and
      e0.(AssignExpr).getLValue().getType().getSize() =
        mexp.getConversion().getConversion().getType().getSize()
      or
      mexp.getEnclosingElement().(ComparisonOperation).hasOperands(mexp, e0) and
      e0.getType().getSize() = mexp.getConversion().getConversion().getType().getSize()
      or
      e0.(FunctionCall)
          .getTarget()
          .getParameter(argumentPosition(e0.(FunctionCall), mexp, _))
          .getType()
          .getSize() = mexp.getConversion().getConversion().getType().getSize()
    )
  )
}

/** Holds if the situation of a possible signed overflow used in pointer arithmetic is found. */
predicate signSmallerWithEqualSizes(MulExpr mexp) {
  exists(Expr e1, Expr e2 |
    mexp.hasOperands(e1, e2) and
    not e1.isConstant() and
    not e1.hasConversion() and
    not e1.hasConversion() and
    (
      e2.isConstant() or
      not e2.hasConversion()
    ) and
    mexp.getConversion+().getUnderlyingType().getSize() = e1.getUnderlyingType().getSize() and
    (
      e2.isConstant() or
      mexp.getConversion+().getUnderlyingType().getSize() = e2.getUnderlyingType().getSize()
    ) and
    mexp.getConversion+().getUnderlyingType().getSize() = e1.getUnderlyingType().getSize() and
    exists(AssignExpr ae |
      ae.getRValue() = mexp.getParent*() and
      ae.getRValue().getUnderlyingType().(IntegralType).isUnsigned() and
      ae.getLValue().getUnderlyingType().(IntegralType).isSigned() and
      (
        not exists(DivExpr de | mexp.getParent*() = de)
        or
        exists(DivExpr de, Expr ec |
          e2.isConstant() and
          de.hasOperands(mexp.getParent*(), ec) and
          ec.isConstant() and
          e2.getValue().toInt() > ec.getValue().toInt()
        )
      ) and
      exists(PointerAddExpr pa |
        ae.getASuccessor+() = pa and
        pa.getAnOperand().(VariableAccess).getTarget() = ae.getLValue().(VariableAccess).getTarget()
      )
    )
  )
}

from MulExpr mexp, string msg
where
  conversionDoneLate(mexp) and
  msg = "This transformation is applied after multiplication."
  or
  signSmallerWithEqualSizes(mexp) and
  msg = "Possible signed overflow followed by offset of the pointer out of bounds."
select mexp, msg
