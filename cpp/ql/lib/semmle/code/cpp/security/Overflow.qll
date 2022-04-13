/**
 * Provides predicates for reasoning about when the value of an expression is
 * guarded by an operation such as `<`, which confines its range.
 */

import cpp
import semmle.code.cpp.controlflow.Dominance
// `GlobalValueNumbering` is only imported to prevent IR re-evaluation.
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import semmle.code.cpp.controlflow.Guards

/**
 * Holds if the value of `use` is guarded using `abs`.
 */
predicate guardedAbs(Operation e, Expr use) {
  exists(FunctionCall fc | fc.getTarget().getName() = ["abs", "labs", "llabs", "imaxabs"] |
    fc.getArgument(0).getAChild*() = use and
    exists(GuardCondition c | c.ensuresLt(fc, _, _, e.getBasicBlock(), true))
  )
}

/**
 * Holds if the value of `use` is guarded to be less than something, and `e`
 * is in code controlled by that guard (where the guard condition held).
 */
pragma[nomagic]
predicate guardedLesser(Operation e, Expr use) {
  exists(GuardCondition c | c.ensuresLt(use, _, _, e.getBasicBlock(), true))
  or
  guardedAbs(e, use)
}

/**
 * Holds if the value of `use` is guarded to be greater than something, and `e`
 * is in code controlled by that guard (where the guard condition held).
 */
pragma[nomagic]
predicate guardedGreater(Operation e, Expr use) {
  exists(GuardCondition c | c.ensuresLt(use, _, _, e.getBasicBlock(), false))
  or
  guardedAbs(e, use)
}

/**
 * Gets a use of a given variable `v`.
 */
VariableAccess varUse(LocalScopeVariable v) { result = v.getAnAccess() }

/**
 * Holds if `e` potentially overflows and `use` is an operand of `e` that is not guarded.
 */
predicate missingGuardAgainstOverflow(Operation e, VariableAccess use) {
  // Since `e` is guarenteed to be a `BinaryArithmeticOperation`, a `UnaryArithmeticOperation` or
  // an `AssignArithmeticOperation` by the other constraints in this predicate, we know that
  // `convertedExprMightOverflowPositively` will have a result even when `e` is not analyzable
  // by `SimpleRangeAnalysis`.
  convertedExprMightOverflowPositively(e) and
  use = e.getAnOperand() and
  exists(LocalScopeVariable v | use.getTarget() = v |
    // overflow possible if large
    e instanceof AddExpr and not guardedLesser(e, varUse(v))
    or
    e instanceof AssignAddExpr and not guardedLesser(e, varUse(v))
    or
    e instanceof IncrementOperation and
    not guardedLesser(e, varUse(v)) and
    v.getUnspecifiedType() instanceof IntegralType
    or
    // overflow possible if large or small
    e instanceof MulExpr and
    not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v)))
    or
    // overflow possible if large or small
    e instanceof AssignMulExpr and
    not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v)))
  )
}

/**
 * Holds if `e` potentially underflows and `use` is an operand of `e` that is not guarded.
 */
predicate missingGuardAgainstUnderflow(Operation e, VariableAccess use) {
  // Since `e` is guarenteed to be a `BinaryArithmeticOperation`, a `UnaryArithmeticOperation` or
  // an `AssignArithmeticOperation` by the other constraints in this predicate, we know that
  // `convertedExprMightOverflowNegatively` will have a result even when `e` is not analyzable
  // by `SimpleRangeAnalysis`.
  convertedExprMightOverflowNegatively(e) and
  use = e.getAnOperand() and
  exists(LocalScopeVariable v | use.getTarget() = v |
    // underflow possible if use is left operand and small
    use = e.(SubExpr).getLeftOperand() and not guardedGreater(e, varUse(v))
    or
    use = e.(AssignSubExpr).getLValue() and not guardedGreater(e, varUse(v))
    or
    // underflow possible if small
    e instanceof DecrementOperation and
    not guardedGreater(e, varUse(v)) and
    v.getUnspecifiedType() instanceof IntegralType
    or
    // underflow possible if large or small
    e instanceof MulExpr and
    not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v)))
    or
    // underflow possible if large or small
    e instanceof AssignMulExpr and
    not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v)))
  )
}
