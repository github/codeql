/**
 * Provides Java-specific definitions for bounds.
 */

private import semmle.code.java.dataflow.SSA as Ssa
private import java as J
private import semmle.code.java.dataflow.RangeUtils as RU

class SsaVariable = Ssa::SsaVariable;

class Expr = J::Expr;

class IntegralType = J::IntegralType;

class ConstantIntegerExpr = RU::ConstantIntegerExpr;

/** Holds if `e` is a bound expression and it is not an SSA variable read. */
predicate nonSsaVariableBoundedExpr(Expr e) {
  e.(J::FieldRead).getField() instanceof J::ArrayLengthField and
  not exists(SsaVariable v | e = v.getAUse())
}
