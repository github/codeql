/**
 * Provides C#-specific definitions for bounds.
 */

private import csharp as CS
private import semmle.code.csharp.dataflow.SSA::Ssa as Ssa
private import semmle.code.csharp.dataflow.internal.rangeanalysis.ConstantUtils as CU

class SsaVariable extends Ssa::Definition {
  /** Gets a read of the source variable underlying this SSA definition. */
  Expr getAUse() { result = getARead() }
}

class Expr = CS::Expr;

class IntegralType = CS::IntegralType;

class ConstantIntegerExpr = CU::ConstantIntegerExpr;

/** Holds if `e` is a bound expression and it is not an SSA variable read. */
predicate interestingExprBound(Expr e) { CU::systemArrayLengthAccess(e.(CS::PropertyRead)) }
