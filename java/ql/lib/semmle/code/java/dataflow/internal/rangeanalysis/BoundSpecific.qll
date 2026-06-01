/**
 * Provides Java-specific definitions for bounds.
 */
overlay[local?]
module;

private import java as J
private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.dataflow.RangeUtils as RU
private import codeql.rangeanalysis.Bound as SharedBound

module BoundDefs implements SharedBound::BoundDefinitions<J::Location> {
  class SsaVariable extends Ssa::SsaDefinition {
    /** Gets a use of this variable. */
    Expr getAUse() { result = super.getARead() }
  }

  class SsaSourceVariable = Ssa::SourceVariable;

  class Type = J::Type;

  class Expr = J::Expr;

  class IntegralType = J::IntegralType;

  class ConstantIntegerExpr = RU::ConstantIntegerExpr;

  /** Holds if `e` is a bound expression and it is not an SSA variable read. */
  predicate interestingExprBound(Expr e) {
    e.(J::FieldRead).getField() instanceof J::ArrayLengthField
  }
}
