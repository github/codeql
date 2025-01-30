import cpp
private import semmle.code.cpp.ir.dataflow.DataFlow

/**
 * Holds if `v` is a member variable of `c` that looks like it might be variable sized
 * in practice. For example:
 * ```
 * struct myStruct { // c
 *   int amount;
 *   char data[1]; // v
 * };
 * ```
 * or
 * ```
 * struct myStruct { // c
 *   int amount;
 *   char data[]; // v
 * };
 * ```
 * This requires that `v` is an array of size 0 or 1, or that the array has no size.
 */
predicate memberMayBeVarSize(Class c, MemberVariable v) {
  c = v.getDeclaringType() and
  exists(ArrayType t | t = v.getUnspecifiedType() | not t.getArraySize() > 1)
}

/**
 * Given a chain of accesses of the form `x.f1.f2...fn` this
 * predicate gives the type of `x`. Note that `x` may be an implicit
 * `this` expression.
 */
private Class getRootType(FieldAccess fa) {
  // If the object is accessed inside a member function then the root will
  // be a(n implicit) `this`. And the root type will be the type of `this`.
  exists(VariableAccess root |
    root = fa.getQualifier*() and
    result =
      root.getQualifier()
          .(ThisExpr)
          .getUnspecifiedType()
          .(PointerType)
          .getBaseType()
          .getUnspecifiedType()
  )
  or
  // Otherwise, if this is not inside a member function there will not be
  // a(n implicit) `this`. And the root type is the type of the outermost
  // access.
  exists(VariableAccess root |
    root = fa.getQualifier+() and
    not exists(root.getQualifier()) and
    result = root.getUnspecifiedType()
  )
}

/**
 * Gets the size of the buffer access at `va`.
 */
private int getSize(VariableAccess va) {
  exists(Variable v | va.getTarget() = v |
    // If `v` is not a field then the size of the buffer is just
    // the size of the type of `v`.
    exists(Type t |
      t = v.getUnspecifiedType() and
      not v instanceof Field and
      not t instanceof ReferenceType and
      result = t.getSize()
    )
    or
    exists(Class c |
      // Otherwise, we find the "outermost" object and compute the size
      // as the difference between the size of the type of the "outermost
      // object" and the offset of the field relative to that type.
      // For example, consider the following structs:
      // ```
      // struct S {
      //   uint32_t x;
      //   uint32_t y;
      // };
      // struct S2 {
      //   S s;
      //   uint32_t z;
      // };
      // ```
      // Given an object `S2 s2` the size of the buffer `&s2.s.y`
      // is the size of the base object type (i.e., `S2`) minutes the offset
      // of `y` relative to the type `S2` (i.e., `4`). So the size of the
      // buffer is `12 - 4 = 8`.
      c = getRootType(va) and
      result = c.getSize() - v.(Field).getOffsetInClass(c)
    )
  )
}

/**
 * Holds if `bufferExpr` is an allocation-like expression.
 *
 * This includes both actual allocations, as well as various operations that return a pointer to
 * stack-allocated objects.
 */
private int isSource(Expr bufferExpr, Element why) {
  exists(Variable bufferVar | bufferVar = bufferExpr.(VariableAccess).getTarget() |
    // buffer is a fixed size array
    result = bufferVar.getUnspecifiedType().(ArrayType).getSize() and
    why = bufferVar and
    not memberMayBeVarSize(_, bufferVar) and
    // zero sized arrays are likely to have special usage, for example
    // behaving a bit like a 'union' overlapping other fields.
    not result = 0
    or
    // buffer is an initialized array, e.g., int buffer[] = {1, 2, 3};
    why = bufferVar.getInitializer().getExpr() and
    (
      why instanceof AggregateLiteral or
      why instanceof StringLiteral
    ) and
    result = why.(Expr).getType().(ArrayType).getSize() and
    not exists(bufferVar.getUnspecifiedType().(ArrayType).getSize())
  )
  or
  // buffer is a fixed size dynamic allocation
  result = bufferExpr.(AllocationExpr).getSizeBytes() and
  why = bufferExpr
  or
  exists(Variable v |
    v = why and
    // buffer is the address of a variable
    why = bufferExpr.(AddressOfExpr).getAddressable() and
    result = getSize(bufferExpr.(AddressOfExpr).getOperand())
  )
}

/** Same as `getBufferSize`, but with the `why` column projected away to prevent large duplications. */
pragma[nomagic]
int getBufferSizeProj(Expr bufferExpr) { result = getBufferSize(bufferExpr, _) }

/**
 * Get the size in bytes of the buffer pointed to by an expression (if this can be determined).
 */
language[monotonicAggregates]
int getBufferSize(Expr bufferExpr, Element why) {
  result = isSource(bufferExpr, why)
  or
  exists(Class parentClass, VariableAccess parentPtr, int bufferSize, Variable bufferVar |
    bufferVar = bufferExpr.(VariableAccess).getTarget() and
    // buffer is the parentPtr->bufferVar of a 'variable size struct'
    memberMayBeVarSize(parentClass, bufferVar) and
    why = bufferVar and
    parentPtr = bufferExpr.(VariableAccess).getQualifier() and
    parentPtr.getTarget().getUnspecifiedType().(PointerType).getBaseType() = parentClass and
    result = getBufferSizeProj(parentPtr) + bufferSize - parentClass.getSize()
  |
    if exists(bufferVar.getType().getSize())
    then bufferSize = bufferVar.getType().getSize()
    else bufferSize = 0
  )
  or
  // dataflow (all sources must be the same size)
  result = unique(Expr def | DataFlow::localExprFlowStep(def, bufferExpr) | getBufferSizeProj(def)) and
  exists(Expr def | DataFlow::localExprFlowStep(def, bufferExpr) | exists(getBufferSize(def, why)))
}
