/**
 * Provides classes for representing abstract bounds for use in, for example, range analysis.
 */
overlay[local?]
module;

private import csharp as CS
private import semmle.code.csharp.dataflow.SSA::Ssa
private import semmle.code.csharp.dataflow.internal.rangeanalysis.ConstantUtils as CU
private import semmle.code.csharp.dataflow.internal.rangeanalysis.RangeUtils as RU
private import semmle.code.csharp.dataflow.internal.rangeanalysis.SsaUtils as SU
private import codeql.rangeanalysis.Bound as SharedBound

/** Provides C#-specific definitions for bounds. */
private module BoundDefs implements SharedBound::BoundDefinitions<CS::Location> {
  class Type = CS::Type;

  class SsaVariable = SU::SsaVariable;

  class SsaSourceVariable = SourceVariable;

  class Expr = CS::ControlFlowNodes::ExprNode;

  class IntegralType = CS::IntegralType;

  class ConstantIntegerExpr = CU::ConstantIntegerExpr;

  /** Holds if `e` is a bound expression and it is not an SSA variable read. */
  predicate interestingExprBound(Expr e) { CU::systemArrayLengthAccess(e.getExpr()) }
}

import SharedBound::Bound<CS::Location, BoundDefs>
