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
  )
}

/**
 * Holds if `c` uses the casting based range pattern, which could be replaced with `instanceof type`.
 */
predicate usesCastingBasedInstanceof(Class c, Type type) {
  instanceofThisInCharPred(c, type) and
  // require that there is a call to the range class that matches the name of the enclosing predicate
  exists(InlineCast cast, MemberCall call |
    cast = getAThisCast(c, type) and
    call.getBase() = cast and
    cast.getEnclosingPredicate().getName() = call.getMemberName()
  )
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

predicate usesFieldBasedInstanceof(Class c, TypeExpr type, FieldDecl field, ComparisonFormula comp) {
  exists(FieldAccess fieldAccess |
    c.getCharPred().getBody() = comp or
    c.getCharPred().getBody().(Conjunction).getAnOperand() = comp
  |
    comp.getOperator() = "=" and
    comp.getEnclosingPredicate() = c.getCharPred() and
    comp.getAnOperand() instanceof ThisAccess and
    comp.getAnOperand() = fieldAccess and
    fieldAccess.getDeclaration() = field and
    field.getVarDecl().getTypeExpr() = type
  ) and
  // require that there is a call to the range field that matches the name of the enclosing predicate
  exists(FieldAccess access, MemberCall call |
    access = getARangeFieldAccess(c, field, _) and
    call.getBase() = access and
    access.getEnclosingPredicate().getName() = call.getMemberName()
  )
}

FieldAccess getARangeFieldAccess(Class c, FieldDecl field, string name) {
  exists(MemberCall call |
    result = call.getBase() and
    result.getDeclaration() = field and
    name = call.getMemberName() and
    call.getEnclosingPredicate().(ClassPredicate).getParent() = c
  )
}
