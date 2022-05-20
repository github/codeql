/**
 * @name Left shift by more than the type width
 * @description Left-shifting an integer by more than its type width indicates a mistake.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/lshift-larger-than-type-width
 * @tags correctness
 */

import java

int integralTypeWidth(IntegralType t) {
  if t.hasName("long") or t.hasName("Long") then result = 64 else result = 32
}

from LShiftExpr shift, IntegralType t, int v, string typname, int width
where
  shift.getLeftOperand().getType() = t and
  shift.getRightOperand().(CompileTimeConstantExpr).getIntValue() = v and
  width = integralTypeWidth(t) and
  v >= width and
  typname = ("a " + t.toString()).regexpReplaceAll("a ([aeiouAEIOU])", "an $1")
select shift,
  "Left-shifting " + typname + " by more than " + width + " truncates the shift amount from " + v +
    " to " + (v % width)
