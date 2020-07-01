/**
 * @name Short-circuiting operator applied to flag
 * @description A short-circuiting logical operator is applied to what looks like a flag.
 *              This may be a typo for a bitwise operator.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/logical-operator-applied-to-flag
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-480
 */

import cpp

/**
 * Gets the value of an expression that is a candidate for a violation, and its constant value.
 * We look for constant operands of binary logical operations other than 0 and 1.
 */
float candidateExpr(Expr e) {
  exists(BinaryLogicalOperation blo |
    e = blo.getAnOperand() and
    e.isConstant() and
    result = e.getValue().toFloat() and
    // exclusions
    not e.isFromTemplateInstantiation(_) and
    not e instanceof SizeofOperator and
    not inMacroExpansion(blo) and
    // exclude values 0 and 1
    result != 0.0 and
    result != 1.0
  )
}

from Expr e, float v, int l, string msg
where
  v = candidateExpr(e) and
  // before reporting an error, we check that the candidate is either a hex/octal
  // literal, or its value is a power of two.
  l = v.log2().floor() and
  if v = 2.pow(l)
  then
    msg =
      "Operand to short-circuiting operator looks like a flag (" + v + " = 2 ^ " + l +
        "), may be typo for bitwise operator."
  else
    exists(string kind |
      (
        e instanceof HexLiteral and kind = "a hexadecimal literal"
        or
        e instanceof OctalLiteral and kind = "an octal literal"
      ) and
      msg =
        "Operand to short-circuiting operator is " + kind +
          ", and therefore likely a flag; a bitwise operator may be intended."
    )
select e, msg
