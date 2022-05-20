import go

/** Gets the string representation of the complex number `real` + `imag`*i */
bindingset[real, imag]
string complexToString(float real, float imag) {
  result = "(" + real.toString() + " + " + imag.toString() + "i)"
}

string longString(Expr e) {
  if e instanceof BinaryExpr
  then
    result =
      longString(e.(BinaryExpr).getLeftOperand()) + " " + e.(BinaryExpr).getOperator() + " " +
        longString(e.(BinaryExpr).getRightOperand())
  else result = e.toString()
}

from CallExpr c, Expr e, string val
where
  (e = c.getAnArgument() or e = c.getAnArgument().getAChildExpr()) and
  (
    val = e.getBoolValue().toString()
    or
    val = e.getStringValue()
    or
    val = e.getNumericValue().toString() + ", " + e.getExactValue()
    or
    exists(float r, float i | e.hasComplexValue(r, i) |
      val = complexToString(r, i) + ", " + e.getExactValue()
    )
  )
select e, longString(e), val
