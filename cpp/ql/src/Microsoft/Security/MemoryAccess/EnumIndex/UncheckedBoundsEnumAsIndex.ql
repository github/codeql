/**
 * @name EnumIndex
 * @description Code using enumerated types as indexes into arrays will often check for
 *              an upper bound to ensure the index is not out of range.
 *              By default an enum variable is signed, and therefore it is important to ensure
 *              that it cannot take on a negative value. When the enum is subsequently used
 *              to index an array, or worse still an array of function pointers, then a negative
 *              enum value would lead to potentially arbitrary memory being read, used and/or executed.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/microsoft/public/enum-index
 * @tags security
 *       external/cwe/cwe-125
 *       external/microsoft/c33010
 */

import cpp
import semmle.code.cpp.controlflow.Guards
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/**
 * Holds if `ec` is the upper bound of an enum
 */
predicate isUpperBoundEnumValue(EnumConstant ec) {
  not exists(EnumConstant ec2, Enum enum | enum = ec2.getEnclosingElement() |
    enum = ec.getEnclosingElement() and
    ec2.getValue().toInt() > ec.getValue().toInt()
  )
}

/**
 * Holds if 'eca' is an access to the upper bound of an enum
 */
predicate isUpperBoundEnumAccess(EnumConstantAccess eca) {
  exists(EnumConstant ec |
    varbind(eca, ec) and
    isUpperBoundEnumValue(ec)
  )
}

/**
 * Holds if the expression `e` is accessing the enum constant `ec`
 */
predicate isExpressionAccessingUpperboundEnum(Expr e, EnumConstantAccess ec) {
  isExpressionAccessingUpperboundEnum(e.getAChild(), ec)
  or
  ec = e and
  isUpperBoundEnumAccess(ec)
}

/**
 * Holds if `e` is a child of an If statement
 */
predicate isPartOfAnIfStatement(Expr e) {
  isPartOfAnIfStatement(e.getAChild())
  or
  exists(IfStmt ifs | ifs.getAChild() = e)
}

/**
 * Holds if the variable access `offsetExpr` upper bound is guarded by an If statement GuardCondition
 * that is using the upper bound of an enum to check the upper bound of `offsetExpr`
 */
predicate hasUpperBoundDefinedByEnum(VariableAccess offsetExpr) {
  exists(BasicBlock controlled, StackVariable offsetVar, SsaDefinition def |
    controlled.contains(offsetExpr) and
    linearBoundControlsEnum(controlled, def, offsetVar, Lesser()) and
    offsetExpr = def.getAUse(offsetVar)
  )
}

pragma[noinline]
predicate linearBoundControlsEnum(
  BasicBlock controlled, SsaDefinition def, StackVariable offsetVar, RelationDirection direction
) {
  exists(GuardCondition guard |
    exists(boolean branch |
      guard.controls(controlled, branch) and
      cmpWithLinearBound(guard, def.getAUse(offsetVar), direction, branch)
    ) and
    exists(EnumConstantAccess enumca | isExpressionAccessingUpperboundEnum(guard, enumca)) and
    isPartOfAnIfStatement(guard)
  )
}

/**
 * Holds if the variable access `offsetExpr` lower bound is guarded
 */
predicate hasLowerBound(VariableAccess offsetExpr) {
  exists(BasicBlock controlled, StackVariable offsetVar, SsaDefinition def |
    controlled.contains(offsetExpr) and
    linearBoundControls(controlled, def, offsetVar, Greater()) and
    offsetExpr = def.getAUse(offsetVar)
  )
}

pragma[noinline]
predicate linearBoundControls(
  BasicBlock controlled, SsaDefinition def, StackVariable offsetVar, RelationDirection direction
) {
  exists(GuardCondition guard, boolean branch |
    guard.controls(controlled, branch) and
    cmpWithLinearBound(guard, def.getAUse(offsetVar), direction, branch) and
    isPartOfAnIfStatement(guard)
  )
}

from VariableAccess offset, ArrayExpr array
where
  offset = array.getArrayOffset() and
  hasUpperBoundDefinedByEnum(offset) and
  not hasLowerBound(offset) and
  exists(IntegralType t |
    t = offset.getUnderlyingType() and
    not t.isUnsigned()
  ) and
  lowerBound(offset.getFullyConverted()) < 0
select offset,
  "When accessing array " + array.getArrayBase() + " with index " + offset +
    ", the upper bound of an enum is used to check the upper bound of the array, but the lower bound is not checked."
