/**
 * @name Sign check of bitwise operation
 * @description Checking the sign of the result of a bitwise operation may yield unexpected results.
 * @kind problem
 * @problem.severity warning
 * @id js/bitwise-sign-check
 * @tags reliability
 *       correctness
 * @precision low
 */

import javascript

/**
 * Holds if `b` is a bitwise operation whose result can safely be compared
 * to zero without risking unexpected results due to sign bits.
 *
 * For example, projecting out constant bit patterns less than 2<sup>31</sup>
 * is safe, as are shifts by small constant integers.
 */
predicate acceptableSignCheck(BitwiseExpr b) {
  // projecting out constant bit patterns not containing the sign bit is fine
  b.(BitAndExpr).getRightOperand().getIntValue() <= 2147483647
  or
  /*
   * `| 0` and `0 |` are popular ways of converting a value to an integer;
   * `>> 0`, `<< 0`, `^ 0` and `0 ^` achieve the same effect;
   * `& 0` is zero, as are `0 <<`, `0 >>` and `0 >>>`;
   * so any binary bitwise operation involving zero is acceptable, _except_ for `x >>> 0`,
   * which amounts to a cast to unsigned int
   */

  exists(int i |
    b.(BinaryExpr).getChildExpr(i).getIntValue() = 0 and
    not (b instanceof URShiftExpr and i = 1)
  )
  or
  /*
   * `<< 16 >> 16` is how Emscripten converts values to short integers; since this
   * is sign-preserving, we shouldn't flag it (and we allow arbitrary shifts, not just 16-bit ones)
   */

  exists(RShiftExpr rsh, LShiftExpr lsh |
    rsh = b and
    lsh = rsh.getLeftOperand().getUnderlyingValue() and
    lsh.getRightOperand().getIntValue() = rsh.getRightOperand().getIntValue()
  )
}

from Comparison e, BitwiseExpr b
where
  b = e.getLeftOperand().getUnderlyingValue() and
  not e instanceof EqualityTest and
  e.getRightOperand().getIntValue() = 0 and
  not acceptableSignCheck(b)
select e, "Sign check of a bitwise operation"
