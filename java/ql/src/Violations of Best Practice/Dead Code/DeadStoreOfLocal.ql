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

predicate excludedInit(Type t, Expr decl) {
  exists(Expr init | flowStep(decl, init) |
    // The `null` literal for reference types.
    t instanceof RefType and init instanceof NullLiteral
    or
    // The default value for primitive types.
    init = t.(PrimitiveType).getADefaultValue()
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
