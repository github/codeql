/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */

import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.rangeanalysis.internal.SignAnalysisCommon as Sign
private import semmle.code.cpp.ir.rangeanalysis.internal.SignAnalysisSpecific::Private as SignSpecific

predicate positive(Operand operand) {
  exists(SignSpecific::Expr e | e.getIROperand() = operand | Sign::positive(e))
}

predicate negative(Operand operand) {
  exists(SignSpecific::Expr e | e.getIROperand() = operand | Sign::negative(e))
}

predicate strictlyPositive(Operand operand) {
  exists(SignSpecific::Expr e | e.getIROperand() = operand | Sign::strictlyPositive(e))
}

predicate strictlyNegative(Operand operand) {
  exists(SignSpecific::Expr e | e.getIROperand() = operand | Sign::strictlyNegative(e))
}
