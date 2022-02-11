/**
 * Provides Java-specific definitions for bounds.
 */

private import java as J
private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.dataflow.RangeUtils as RU
private import semmle.code.java.dataflow.ConstantAnalysis as Const

class SsaVariable = Ssa::SsaVariable;

class Expr = J::Expr;

class IntegralType = J::IntegralType;

class ConstantIntegerExpr = Const::ConstantIntegerExpr;

/** Holds if `e` is a bound expression and it is not an SSA variable read. */
predicate interestingExprBound(Expr e) {
  e.(J::FieldRead).getField() instanceof J::ArrayLengthField
}
