private import cpp

/**
 * Given a type, get the type that would result by applying "pointer decay".
 * A function type becomes a pointer to that function type, and an array type
 * becomes a pointer to the element type of the array. If the specified type
 * is not subject to pointer decay, this predicate does not hold.
 */
private Type getDecayedType(Type type) {
  result.(FunctionPointerType).getBaseType() = type.(RoutineType) or
  result.(PointerType).getBaseType() = type.(ArrayType).getBaseType()
}

/**
 * Holds if the specified variable is a structured binding with a non-reference
 * type.
 */
predicate isNonReferenceStructuredBinding(Variable v) {
  v.isStructuredBinding() and
  not v.getUnspecifiedType() instanceof ReferenceType
}

/**
 * Gets the type that `v` is declared with.
 */
private Type getDeclaredType(Variable v) {
  result = v.(Parameter).getDefinition().getType()
  or
  not v.(Parameter).hasDefinition() and
  result = v.getType()
}

/**
 * Get the actual type of the specified variable, as opposed to the declared type.
 * This returns the type of the variable after any pointer decay is applied, and
 * after any unsized array type has its size inferred from the initializer.
 */
Type getVariableType(Variable v) {
  exists(Type declaredType, Type unspecifiedType |
    declaredType = getDeclaredType(v) and
    unspecifiedType = declaredType.getUnspecifiedType()
  |
    if v instanceof Parameter
    then
      result = getDecayedType(unspecifiedType)
      or
      not exists(getDecayedType(unspecifiedType)) and result = declaredType
    else
      if unspecifiedType instanceof ArrayType and not unspecifiedType.(ArrayType).hasArraySize()
      then
        result = v.getInitializer().getExpr().getType()
        or
        not exists(v.getInitializer()) and result = declaredType
      else
        if isNonReferenceStructuredBinding(v)
        then
          // The extractor ensures `r` exists when `isNonReferenceStructuredBinding(v)` holds.
          exists(LValueReferenceType r | r.getBaseType() = unspecifiedType | result = r)
        else result = declaredType
  )
}

/**
 * Holds if the database contains a `switchCase` label with the specified minimum `minValue`
 * and maximum `maxValue` value.
 */
predicate hasCaseEdge(SwitchCase switchCase, string minValue, string maxValue) {
  minValue = switchCase.getExpr().getFullyConverted().getValue() and
  if exists(switchCase.getEndExpr())
  then maxValue = switchCase.getEndExpr().getFullyConverted().getValue()
  else maxValue = minValue
}
