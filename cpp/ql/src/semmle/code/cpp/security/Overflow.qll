import cpp
import semmle.code.cpp.controlflow.Dominance

/* Guarding */

/** is the size of this use guarded using 'abs'? */
predicate guardedAbs(BinaryArithmeticOperation e, Expr use) {
  exists(FunctionCall fc |
    fc.getTarget().getName() = "abs" |
    fc.getArgument(0).getAChild*() = use
    and guardedLesser(e, fc)
  )
}

/** is the size of this use guarded to be less than something? */
predicate guardedLesser(BinaryArithmeticOperation e, Expr use) {
  exists(IfStmt c, RelationalOperation guard |
    use = guard.getLesserOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    iDominates*(c.getThen(), e.getEnclosingStmt())
  )
  or exists(Loop c, RelationalOperation guard |
    use = guard.getLesserOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    iDominates*(c.getStmt(), e.getEnclosingStmt())
  )
  or exists(ConditionalExpr c, RelationalOperation guard |
    use = guard.getLesserOperand().getAChild*() and
    guard = c.getCondition().getAChild*() and
    c.getThen().getAChild*() = e
  )
  or guardedAbs(e, use)
}

/** is the size of this use guarded to be greater than something? */
predicate guardedGreater(BinaryArithmeticOperation e, Expr use) {
  exists(IfStmt c, RelationalOperation guard |
    use = guard.getGreaterOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    iDominates*(c.getThen(), e.getEnclosingStmt())
  )
  or exists(Loop c, RelationalOperation guard |
    use = guard.getGreaterOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    iDominates*(c.getStmt(), e.getEnclosingStmt())
  )
  or exists(ConditionalExpr c, RelationalOperation guard |
    use = guard.getGreaterOperand().getAChild*() and
    guard = c.getCondition().getAChild*() and
    c.getThen().getAChild*() = e
  )
  or guardedAbs(e, use)
}

/** a use of a given variable */
VariableAccess varUse(LocalScopeVariable v) {
  result = v.getAnAccess()
}

/** is e not guarded against overflow by use? */
predicate missingGuardAgainstOverflow(BinaryArithmeticOperation e, VariableAccess use) {
  use = e.getAnOperand() and
  exists(LocalScopeVariable v | use.getTarget() = v |
    // overflow possible if large
    (e instanceof AddExpr and not guardedLesser(e, varUse(v))) or
    // overflow possible if large or small
    (e instanceof MulExpr and
      not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v))))
  )
}

/** is e not guarded against underflow by use? */
predicate missingGuardAgainstUnderflow(BinaryArithmeticOperation e, VariableAccess use) {
  use = e.getAnOperand() and
  exists(LocalScopeVariable v | use.getTarget() = v |
    // underflow possible if use is left operand and small
    (e instanceof SubExpr and
      (use = e.getLeftOperand() and not guardedGreater(e, varUse(v)))) or
    // underflow possible if large or small
    (e instanceof MulExpr and
      not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v))))
  )
}
