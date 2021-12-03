import cpp
import semmle.code.cpp.ir.internal.IntegerConstant as Ints

bindingset[n]
string resultString(int n) {
  if Ints::hasValue(n) then result = n.toString() else result = "unknown"
}

from string expr, int res
where
  expr = "0 + 0" and res = Ints::add(0, 0)
  or
  expr = "0 + INT_MAX" and res = Ints::add(0, Ints::maxValue())
  or
  expr = "0 + -INT_MAX" and res = Ints::add(0, Ints::minValue())
  or
  expr = "1 + INT_MAX" and res = Ints::add(1, Ints::maxValue())
  or
  expr = "1 + -INT_MAX" and res = Ints::add(1, Ints::minValue())
  or
  expr = "unknown + unknown" and res = Ints::add(Ints::unknown(), Ints::unknown())
  or
  expr = "5 + unknown" and res = Ints::add(5, Ints::unknown())
  or
  expr = "unknown + 5" and res = Ints::add(Ints::unknown(), 5)
  or
  expr = "0 - INT_MAX" and res = Ints::sub(0, Ints::maxValue())
  or
  expr = "0 - -INT_MAX" and res = Ints::sub(0, Ints::minValue())
  or
  expr = "-1 - INT_MAX" and res = Ints::sub(-1, Ints::maxValue())
  or
  expr = "-1 - -INT_MAX" and res = Ints::sub(-1, Ints::minValue())
  or
  expr = "unknown - unknown" and res = Ints::sub(Ints::unknown(), Ints::unknown())
  or
  expr = "5 - unknown" and res = Ints::sub(5, Ints::unknown())
  or
  expr = "unknown - 5" and res = Ints::sub(Ints::unknown(), 5)
  or
  expr = "0 * 0" and res = Ints::mul(0, 0)
  or
  expr = "5 * 7" and res = Ints::mul(5, 7)
  or
  expr = "0 * INT_MAX" and res = Ints::mul(0, Ints::maxValue())
  or
  expr = "2 * INT_MAX" and res = Ints::mul(2, Ints::maxValue())
  or
  expr = "-1 * -INT_MAX" and res = Ints::mul(-1, Ints::minValue())
  or
  expr = "INT_MAX * INT_MAX" and res = Ints::mul(Ints::maxValue(), Ints::maxValue())
  or
  expr = "0 * unknown" and res = Ints::mul(0, Ints::unknown())
  or
  expr = "35 / 7" and res = Ints::div(35, 7)
  or
  expr = "35 / 8" and res = Ints::div(35, 8)
  or
  expr = "35 / -7" and res = Ints::div(35, -7)
  or
  expr = "35 / -8" and res = Ints::div(35, -8)
  or
  expr = "-35 / 7" and res = Ints::div(-35, 7)
  or
  expr = "-35 / 8" and res = Ints::div(-35, 8)
  or
  expr = "-35 / -7" and res = Ints::div(-35, -7)
  or
  expr = "-35 / -8" and res = Ints::div(-35, -8)
  or
  expr = "0 / -INT_MAX" and res = Ints::div(0, Ints::minValue())
  or
  expr = "INT_MAX / 0" and res = Ints::div(Ints::maxValue(), 0)
  or
  expr = "0 / unknown" and res = Ints::div(0, Ints::unknown())
  or
  expr = "unknown / 3" and res = Ints::div(Ints::unknown(), 3)
  or
  expr = "unknown / unknown" and res = Ints::div(Ints::unknown(), Ints::unknown())
  or
  expr = "-3 == -3" and res = Ints::compareEQ(-3, -3)
  or
  expr = "-3 == 6" and res = Ints::compareEQ(-3, 6)
  or
  expr = "-3 == unknown" and res = Ints::compareEQ(-3, Ints::unknown())
  or
  expr = "unknown == 6" and res = Ints::compareEQ(Ints::unknown(), 6)
  or
  expr = "unknown == unknown" and res = Ints::compareEQ(Ints::unknown(), Ints::unknown())
  or
  expr = "-3 != -3" and res = Ints::compareNE(-3, -3)
  or
  expr = "-3 != 6" and res = Ints::compareNE(-3, 6)
  or
  expr = "-3 != unknown" and res = Ints::compareNE(-3, Ints::unknown())
  or
  expr = "unknown != 6" and res = Ints::compareNE(Ints::unknown(), 6)
  or
  expr = "unknown != unknown" and res = Ints::compareNE(Ints::unknown(), Ints::unknown())
  or
  expr = "-3 < -3" and res = Ints::compareLT(-3, -3)
  or
  expr = "-3 < 6" and res = Ints::compareLT(-3, 6)
  or
  expr = "-3 < -7" and res = Ints::compareLT(-3, -7)
  or
  expr = "-3 < unknown" and res = Ints::compareLT(-3, Ints::unknown())
  or
  expr = "unknown < 6" and res = Ints::compareLT(Ints::unknown(), 6)
  or
  expr = "unknown < unknown" and res = Ints::compareLT(Ints::unknown(), Ints::unknown())
  or
  expr = "-3 > -3" and res = Ints::compareGT(-3, -3)
  or
  expr = "-3 > 6" and res = Ints::compareGT(-3, 6)
  or
  expr = "-3 > -7" and res = Ints::compareGT(-3, -7)
  or
  expr = "-3 > unknown" and res = Ints::compareGT(-3, Ints::unknown())
  or
  expr = "unknown > 6" and res = Ints::compareGT(Ints::unknown(), 6)
  or
  expr = "unknown > unknown" and res = Ints::compareGT(Ints::unknown(), Ints::unknown())
  or
  expr = "-3 <= -3" and res = Ints::compareLE(-3, -3)
  or
  expr = "-3 <= 6" and res = Ints::compareLE(-3, 6)
  or
  expr = "-3 <= -7" and res = Ints::compareLE(-3, -7)
  or
  expr = "-3 <= unknown" and res = Ints::compareLE(-3, Ints::unknown())
  or
  expr = "unknown <= 6" and res = Ints::compareLE(Ints::unknown(), 6)
  or
  expr = "unknown <= unknown" and res = Ints::compareLE(Ints::unknown(), Ints::unknown())
  or
  expr = "-3 >= -3" and res = Ints::compareGE(-3, -3)
  or
  expr = "-3 >= 6" and res = Ints::compareGE(-3, 6)
  or
  expr = "-3 >= -7" and res = Ints::compareGE(-3, -7)
  or
  expr = "-3 >= unknown" and res = Ints::compareGE(-3, Ints::unknown())
  or
  expr = "unknown >= 6" and res = Ints::compareGE(Ints::unknown(), 6)
  or
  expr = "unknown >= unknown" and res = Ints::compareGE(Ints::unknown(), Ints::unknown())
select expr, resultString(res)
