private import java
private import SSA
private import RangeUtils

/**
 * Holds if `v` is an input to `phi` that is not along a back edge, and the
 * only other input to `phi` is a `null` value.
 *
 * Note that the declared type of `phi` is `SsaVariable` instead of
 * `SsaPhiNode` in order for the reflexive case of `nonNullSsaFwdStep*(..)` to
 * have non-`SsaPhiNode` results.
 */
private predicate nonNullSsaFwdStep(SsaVariable v, SsaVariable phi) {
  exists(SsaExplicitUpdate vnull, SsaPhiNode phi0 | phi0 = phi |
    2 = strictcount(phi0.getAPhiInput()) and
    vnull = phi0.getAPhiInput() and
    v = phi0.getAPhiInput() and
    not backEdge(phi0, v, _) and
    vnull != v and
    vnull.getDefiningExpr().(VariableAssign).getSource() instanceof NullLiteral
  )
}

private predicate nonNullDefStep(Expr e1, Expr e2) {
  exists(ConditionalExpr cond, boolean branch | cond = e2 |
    cond.getBranchExpr(branch) = e1 and
    cond.getBranchExpr(branch.booleanNot()) instanceof NullLiteral
  )
}

/**
 * Gets the definition of `v` provided that `v` is a non-null array with an
 * explicit `ArrayCreationExpr` definition and that the definition does not go
 * through a back edge.
 */
ArrayCreationExpr getArrayDef(SsaVariable v) {
  exists(Expr src |
    v.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() = src and
    nonNullDefStep*(result, src)
  )
  or
  exists(SsaVariable mid |
    result = getArrayDef(mid) and
    nonNullSsaFwdStep(mid, v)
  )
}

/**
 * Holds if `arrlen` is a read of an array `length` field on an array that, if
 * it is non-null, is defined by `def` and that the definition can reach
 * `arrlen` without going through a back edge.
 */
predicate arrayLengthDef(FieldRead arrlen, ArrayCreationExpr def) {
  exists(SsaVariable arr |
    arrlen.getField() instanceof ArrayLengthField and
    arrlen.getQualifier() = arr.getAUse() and
    def = getArrayDef(arr)
  )
}
