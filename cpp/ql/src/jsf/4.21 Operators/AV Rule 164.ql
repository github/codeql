/**
 * @name AV Rule 164
 * @description The right-hand operand of a shift operator shall lie between zero and one less than the width in bits of the left-hand operand.
 * @kind problem
 * @id cpp/jsf/av-rule-164
 * @problem.severity error
 * @precision low
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * We'll check the cases where the value of the RHS can be easily determined only.
 * Include:
 *   - constants and exprs that evaluate to constants, and
 *   - variables that are only assigned constants
 */

predicate possibleValue(Variable v, Expr value) {
  v.getInitializer().getExpr() = value or
  value = v.getAnAssignedValue()
}

predicate constantValue(Expr e, int value) {
  e.getUnspecifiedType() instanceof IntegralType and
  (
    // Either the expr has a constant value
    value = e.getValue().toInt()
    or
    // The expr is a variable access and all values of the variable are constant
    exists(VariableAccess va |
      va = e and
      forall(Expr init | possibleValue(va.getTarget(), init) | constantValue(init, _)) and
      exists(Expr init | possibleValue(va.getTarget(), init) | constantValue(init, value))
    )
  )
}

predicate violation(BinaryBitwiseOperation op, int lhsBytes, int value) {
  (op instanceof LShiftExpr or op instanceof RShiftExpr) and
  constantValue(op.getRightOperand(), value) and
  lhsBytes = op.getLeftOperand().getExplicitlyConverted().getType().getSize() and
  (value < 0 or value >= lhsBytes * 8)
}

from BinaryBitwiseOperation op, int lhsBytes, int canonicalValue
where canonicalValue = min(int v | violation(op, lhsBytes, v))
select op,
  "AV Rule 164: The right-hand operand (here a value is " + canonicalValue.toString() +
    ") of this shift shall lie between 0 and " + (lhsBytes * 8 - 1).toString() + "."
