/**
 * Provides C#-specific definitions for bounds.
 */

private import csharp as CS
private import semmle.code.csharp.dataflow.SSA::Ssa as Ssa
private import semmle.code.csharp.dataflow.internal.rangeanalysis.ConstantUtils as CU
private import semmle.code.csharp.dataflow.internal.rangeanalysis.RangeUtils as RU
private import semmle.code.csharp.dataflow.internal.rangeanalysis.SsaUtils as SU

class SsaVariable = SU::SsaVariable;

class Expr = CS::ControlFlow::Nodes::ExprNode;

class IntegralType = CS::IntegralType;

class ConstantIntegerExpr = CU::ConstantIntegerExpr;

/** Holds if `e` is a bound expression and it is not an SSA variable read. */
predicate interestingExprBound(Expr e) { CU::systemArrayLengthAccess(e.getExpr()) }
