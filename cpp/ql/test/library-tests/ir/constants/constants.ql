import cpp
import semmle.code.cpp.ir.internal.IntegerConstant as Ints

bindingset[n]
string resultString(int n) {
  if Ints::hasValue(n) then
    result = n.toString()
  else
    result = "unknown"
}

from string expr, int res
where
  expr = "0 + 0" and res = Ints::add(0, 0) or
  expr = "0 + INT_MAX" and res = Ints::add(0, Ints::maxValue()) or
  expr = "0 + -INT_MAX" and res = Ints::add(0, Ints::minValue()) or
  expr = "1 + INT_MAX" and res = Ints::add(1, Ints::maxValue()) or
  expr = "1 + -INT_MAX" and res = Ints::add(1, Ints::minValue()) or
  expr = "unknown + unknown" and res = Ints::add(Ints::unknown(), Ints::unknown()) or
  expr = "5 + unknown" and res = Ints::add(5, Ints::unknown()) or
  expr = "unknown + 5" and res = Ints::add(Ints::unknown(), 5) or
  expr = "0 - INT_MAX" and res = Ints::sub(0, Ints::maxValue()) or
  expr = "0 - -INT_MAX" and res = Ints::sub(0, Ints::minValue()) or
  expr = "-1 - INT_MAX" and res = Ints::sub(-1, Ints::maxValue()) or
  expr = "-1 - -INT_MAX" and res = Ints::sub(-1, Ints::minValue()) or
  expr = "unknown - unknown" and res = Ints::sub(Ints::unknown(), Ints::unknown()) or
  expr = "5 - unknown" and res = Ints::sub(5, Ints::unknown()) or
  expr = "unknown - 5" and res = Ints::sub(Ints::unknown(), 5) or
  expr = "0 * 0" and res = Ints::mul(0, 0) or
  expr = "5 * 7" and res = Ints::mul(5, 7) or
  expr = "0 * INT_MAX" and res = Ints::mul(0, Ints::maxValue()) or
  expr = "2 * INT_MAX" and res = Ints::mul(2, Ints::maxValue()) or
  expr = "-1 * -INT_MAX" and res = Ints::mul(-1, Ints::minValue()) or
  expr = "INT_MAX * INT_MAX" and res = Ints::mul(Ints::maxValue(), Ints::maxValue()) or
  expr = "0 * unknown" and res = Ints::mul(0, Ints::unknown()) or
  expr = "35 / 7" and res = Ints::div(35, 7) or
  expr = "35 / 8" and res = Ints::div(35, 8) or
  expr = "35 / -7" and res = Ints::div(35, -7) or
  expr = "35 / -8" and res = Ints::div(35, -8) or
  expr = "-35 / 7" and res = Ints::div(-35, 7) or
  expr = "-35 / 8" and res = Ints::div(-35, 8) or
  expr = "-35 / -7" and res = Ints::div(-35, -7) or
  expr = "-35 / -8" and res = Ints::div(-35, -8) or
  expr = "0 / -INT_MAX" and res = Ints::div(0, Ints::minValue()) or
  expr = "INT_MAX / 0" and res = Ints::div(Ints::maxValue(), 0) or
  expr = "0 / unknown" and res = Ints::div(0, Ints::unknown()) or
  expr = "unknown / 3" and res = Ints::div(Ints::unknown(), 3) or
  expr = "unknown / unknown" and res = Ints::div(Ints::unknown(), Ints::unknown())
select expr, resultString(res)
