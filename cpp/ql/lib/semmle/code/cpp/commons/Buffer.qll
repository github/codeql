import cpp
import semmle.code.cpp.dataflow.DataFlow

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
 * Get the size in bytes of the buffer pointed to by an expression (if this can be determined).
 */
language[monotonicAggregates]
int getBufferSize(Expr bufferExpr, Element why) {
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
    or
    exists(Class parentClass, VariableAccess parentPtr, int bufferSize |
      // buffer is the parentPtr->bufferVar of a 'variable size struct'
      memberMayBeVarSize(parentClass, bufferVar) and
      why = bufferVar and
      parentPtr = bufferExpr.(VariableAccess).getQualifier() and
      parentPtr.getTarget().getUnspecifiedType().(PointerType).getBaseType() = parentClass and
      (
        if exists(bufferVar.getType().getSize())
        then bufferSize = bufferVar.getType().getSize()
        else bufferSize = 0
      ) and
      result = getBufferSize(parentPtr, _) + bufferSize - parentClass.getSize()
    )
  )
  or
  // buffer is a fixed size dynamic allocation
  result = bufferExpr.(AllocationExpr).getSizeBytes() and
  why = bufferExpr
  or
  exists(DataFlow::ExprNode bufferExprNode |
    // dataflow (all sources must be the same size)
    bufferExprNode = DataFlow::exprNode(bufferExpr) and
    result =
      unique(Expr def |
        DataFlow::localFlowStep(DataFlow::exprNode(def), bufferExprNode)
      |
        getBufferSize(def, _)
      ) and
    // find reason
    exists(Expr def | DataFlow::localFlowStep(DataFlow::exprNode(def), bufferExprNode) |
      why = def or
      exists(getBufferSize(def, why))
    )
  )
  or
  exists(Type bufferType |
    // buffer is the address of a variable
    why = bufferExpr.(AddressOfExpr).getAddressable() and
    bufferType = why.(Variable).getType() and
    result = bufferType.getSize() and
    not bufferType instanceof ReferenceType and
    not any(Union u).getAMemberVariable() = why
  )
  or
  exists(Union bufferType |
    // buffer is the address of a union member; in this case, we
    // take the size of the union itself rather the union member, since
    // it's usually OK to access that amount (e.g. clearing with memset).
    why = bufferExpr.(AddressOfExpr).getAddressable() and
    bufferType.getAMemberVariable() = why and
    result = bufferType.getSize()
  )
}
