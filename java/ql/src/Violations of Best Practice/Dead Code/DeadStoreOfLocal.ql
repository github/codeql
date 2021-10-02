/**
 * @name Assigned value is overwritten
 * @description An assignment to a local variable that is not used before a further assignment is
 *              made has no effect.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/overwritten-assignment-to-local
 * @tags maintainability
 *       useless-code
 *       readability
 *       external/cwe/cwe-563
 */

import java
import DeadLocals

predicate minusOne(MinusExpr e) { e.getExpr().(Literal).getValue() = "1" }

predicate flowStep(Expr decl, Expr init) {
  decl = init
  or
  exists(Field f | f.isFinal() and decl.(FieldAccess).getField() = f |
    init = f.getAnAssignedValue()
  )
  or
  decl.(CastExpr).getExpr() = init
}

predicate isDefaultValueLiteral(Literal l, Type t) {
  t instanceof RefType and l instanceof NullLiteral
  or
  // Checking here for primitive suffices to make sure that literals below are valid default
  t instanceof PrimitiveType and
  (
    l.(BooleanLiteral).getBooleanValue() = false or
    l.(CharacterLiteral).getValue() = 0.toUnicode() or
    l.(DoubleLiteral).getDoubleValue() = 0 or
    l.(FloatingPointLiteral).getFloatValue() = 0 or
    l.(IntegerLiteral).getIntValue() = 0 or
    l.(LongLiteral).getValue() = "0"
  )
}

predicate excludedInit(Type t, Expr decl) {
  exists(Expr init | flowStep(decl, init) |
    isDefaultValueLiteral(init, t)
    or
    // The expression `-1` for integral types.
    t instanceof IntegralType and minusOne(init)
  )
}

from VariableUpdate def, LocalScopeVariable v, SsaExplicitUpdate ssa
where
  def = ssa.getDefiningExpr() and
  v = ssa.getSourceVariable().getVariable() and
  deadLocal(ssa) and
  not expectedDead(ssa) and
  overwritten(ssa) and
  not exists(LocalVariableDeclExpr decl | def = decl |
    excludedInit(decl.getVariable().getType(), decl.getInit())
  )
select def,
  "This assignment to " + v.getName() +
    " is useless: the value is always overwritten before it is read."
