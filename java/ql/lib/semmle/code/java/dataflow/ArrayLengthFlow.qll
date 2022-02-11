private import java
private import semmle.code.java.semantic.SemanticExpr
private import semmle.code.java.semantic.SemanticSSA

/**
 * Holds if `v` is an input to `phi` that is not along a back edge, and the
 * only other input to `phi` is a `null` value.
 *
 * Note that the declared type of `phi` is `SsaVariable` instead of
 * `SsaPhiNode` in order for the reflexive case of `nonNullSsaFwdStep*(..)` to
 * have non-`SsaPhiNode` results.
 */
private predicate nonNullSsaFwdStep(SemSsaVariable v, SemSsaVariable phi) {
  exists(SemSsaExplicitUpdate vnull, SemSsaPhiNode phi0 | phi0 = phi |
    2 = strictcount(phi0.getAPhiInput()) and
    vnull = phi0.getAPhiInput() and
    v = phi0.getAPhiInput() and
    not semBackEdge(phi0, v, _) and
    vnull != v and
    vnull.getDefiningExpr().(SemVariableAssign).getSource() instanceof SemNullLiteral
  )
}

private predicate nonNullDefStep(SemExpr e1, SemExpr e2) {
  exists(ConditionalExpr cond, boolean branch | cond = getJavaExpr(e2) |
    cond.getBranchExpr(branch) = getJavaExpr(e1) and
    cond.getBranchExpr(branch.booleanNot()) instanceof NullLiteral
  )
}

/**
 * Gets the definition of `v` provided that `v` is a non-null array with an
 * explicit `ArrayCreationExpr` definition and that the definition does not go
 * through a back edge.
 */
private ArrayCreationExpr getArrayDef(SemSsaVariable v) {
  exists(SemExpr src |
    v.(SemSsaExplicitUpdate).getDefiningExpr().(SemVariableAssign).getSource() = src and
    nonNullDefStep*(getSemanticExpr(result), src)
  )
  or
  exists(SemSsaVariable mid |
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
  exists(SemSsaVariable arr |
    arrlen.getField() instanceof ArrayLengthField and
    arrlen.getQualifier() = getJavaExpr(arr.getAUse()) and
    def = getArrayDef(arr)
  )
}
