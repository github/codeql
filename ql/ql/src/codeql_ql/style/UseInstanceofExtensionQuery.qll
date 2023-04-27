import ql

/**
 * Gets a class where the charpred has an `this instanceof type` expression.
 */
predicate instanceofThisInCharPred(Class c, Type type) {
  exists(InstanceOf instanceOf |
    instanceOf = c.getCharPred().getBody()
    or
    exists(Conjunction conj |
      conj = c.getCharPred().getBody() and
      instanceOf = conj.getAnOperand()
    )
  |
    instanceOf.getExpr() instanceof ThisAccess and
    type = instanceOf.getType().getResolvedType()
  ) and
  // no existing super-type corresponds to the instanceof type, that is benign.
  not c.getType().getASuperType+() = type
}

/** Gets an inline cast that cases `this` to `type` inside a class predicate for `c`. */
InlineCast getAThisCast(Class c, Type type) {
  exists(MemberCall call |
    call.getEnclosingPredicate() = c.getAClassPredicate() and
    result = call.getBase() and
    result.getBase() instanceof ThisAccess and
    result.getTypeExpr().getResolvedType() = type
  )
}

predicate usesFieldBasedInstanceof(Class c, Type type, FieldDecl field, ComparisonFormula comp) {
  exists(FieldAccess fieldAccess |
    c.getCharPred().getBody() = comp or
    c.getCharPred().getBody().(Conjunction).getAnOperand() = comp
  |
    comp.getOperator() = "=" and
    comp.getEnclosingPredicate() = c.getCharPred() and
    comp.getAnOperand() instanceof ThisAccess and
    comp.getAnOperand() = fieldAccess and
    fieldAccess.getDeclaration() = field and
    field.getVarDecl().getType() = type
  ) and
  not c.getType().getASuperType+() = type
}

FieldAccess getARangeFieldAccess(Class c, FieldDecl field, string name) {
  exists(MemberCall call |
    result = call.getBase() and
    result.getDeclaration() = field and
    name = call.getMemberName() and
    call.getEnclosingPredicate().(ClassPredicate).getParent() = c
  )
}
