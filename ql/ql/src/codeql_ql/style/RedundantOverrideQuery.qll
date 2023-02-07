import ql

/** Holds if `pred` overrides super predicate `sup` by forwarding via `mc`. */
private predicate forwardingOverride(ClassPredicate pred, MemberCall mc, ClassPredicate sup) {
  pred.overrides(sup) and
  mc.getBase() instanceof Super and
  mc.getTarget() = sup and
  not exists(pred.getQLDoc()) and
  forall(int i, VarDecl p | p = pred.getParameter(i) | mc.getArgument(i) = p.getAnAccess()) and
  (
    pred.getBody() =
      any(ComparisonFormula comp |
        comp.getOperator() = "=" and
        comp.getAnOperand() instanceof ResultAccess and
        comp.getAnOperand() = mc and
        pred.getReturnType() = sup.getReturnType()
      )
    or
    pred.getBody() = mc
  )
}

private predicate forwardingOverrideProj(ClassPredicate pred, ClassPredicate sup) {
  forwardingOverride(pred, _, sup)
}

private ClassPredicate getUltimateDef(ClassPredicate p) {
  forwardingOverrideProj*(p, result) and
  not forwardingOverrideProj(result, _)
}

predicate redundantOverride(ClassPredicate pred, ClassPredicate sup) {
  forwardingOverride(pred, _, sup) and
  // overridden to provide more precise QL doc
  not exists(pred.getQLDoc()) and
  // overridden to disambiguate
  not exists(ClassPredicate other |
    getUltimateDef(sup) != getUltimateDef(other) and
    pred.getDeclaringType().getASuperType+() = other.getDeclaringType() and
    not sup.overrides*(other) and
    other.getName() = pred.getName() and
    other.getArity() = pred.getArity()
  )
}
