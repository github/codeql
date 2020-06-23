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
 * Get the actual type of the specified variable, as opposed to the declared type.
 * This returns the type of the variable after any pointer decay is applied, and
 * after any unsized array type has its size inferred from the initializer.
 */
Type getVariableType(Variable v) {
  exists(Type declaredType |
    declaredType = v.getUnspecifiedType() and
    if v instanceof Parameter
    then
      result = getDecayedType(declaredType)
      or
      not exists(getDecayedType(declaredType)) and result = v.getType()
    else
      if declaredType instanceof ArrayType and not declaredType.(ArrayType).hasArraySize()
      then
        result = v.getInitializer().getExpr().getType()
        or
        not exists(v.getInitializer()) and result = v.getType()
      else result = v.getType()
  )
}

/**
 * Holds if the database contains a `case` label with the specified minimum and maximum value.
 */
predicate hasCaseEdge(SwitchCase switchCase, string minValue, string maxValue) {
  minValue = switchCase.getExpr().getFullyConverted().getValue() and
  if exists(switchCase.getEndExpr())
  then maxValue = switchCase.getEndExpr().getFullyConverted().getValue()
  else maxValue = minValue
}
