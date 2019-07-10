import csharp

// TODO: CHECK IF TALKING ABOUT POINTERS HERE MAKES SENSE

/**
 * Given a type, get the type that would result by applying "pointer decay".
 * A function type becomes a pointer to that function type, and an array type
 * becomes a pointer to the element type of the array. If the specified type
 * is not subject to pointer decay, this predicate does not hold.
 */
private Type getDecayedType(Type type) {
  // TODO: CHECK WHAT EXACTLY CAN BE DECAYED IN C#
  // result.(FunctionPointerType).getBaseType() = type.(RoutineType) or
  result.(PointerType).getReferentType() = type.(ArrayType).getElementType()
}

/**
 * Get the actual type of the specified variable, as opposed to the declared type.
 * This returns the type of the variable after any pointer decay is applied, and
 * after any unsized array type has its size inferred from the initializer.
 */
Type getVariableType(Variable v) {
  exists(Type declaredType |
    declaredType = v.getType() and // TODO: IS getUnspecifiedType RELEVANT HERE?
    if v instanceof Parameter then (
      result = getDecayedType(declaredType) or
      not exists(getDecayedType(declaredType)) and result = declaredType
    )
    else if declaredType instanceof ArrayType /*TODO: DO WE NEED TO CHECK FOR ARRAY SIZES? PROBS NOT, ILLEGAL 
     * FOR AN ARRAY TO NOT HAVE SIZE
     *  and not declaredType.(ArrayType).hasArraySize() */ then (
      result = v.getInitializer().getType() or
      not exists(v.getInitializer()) and result = declaredType
    )
    else (
      result = declaredType
    )
  )
}
