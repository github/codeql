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
 * Gets the expression associated with `n`. Unlike `n.asExpr()` this also gets the
 * expression underlying an indirect dataflow node.
 */
private Expr getExpr(DataFlow::Node n, boolean isIndirect) {
  result = n.asExpr() and isIndirect = false
  or
  result = n.asIndirectExpr() and isIndirect = true
}

private DataFlow::Node exprNode(Expr e, boolean isIndirect) { e = getExpr(result, isIndirect) }

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

/** Holds if the value of `n2 + delta` may be equal to the value of `n1`. */
private predicate localFlowIncrStep(DataFlow::Node n1, DataFlow::Node n2, int delta) {
  DataFlow::localFlowStep(n1, n2) and
  (
    exists(IncrementOperation incr |
      n1.asIndirectExpr() = incr.getOperand() and
      delta = -1
    )
    or
    exists(DecrementOperation decr |
      n1.asIndirectExpr() = decr.getOperand() and
      delta = 1
    )
    or
    exists(AddExpr add, Expr e1, Expr e2 |
      add.hasOperands(e1, e2) and
      n1.asIndirectExpr() = e1 and
      delta = -e2.getValue().toInt()
    )
    or
    exists(SubExpr add, Expr e1, Expr e2 |
      add.hasOperands(e1, e2) and
      n1.asIndirectExpr() = e1 and
      delta = e2.getValue().toInt()
    )
  )
}

/**
 * Holds if `n1` may flow to `n2` without passing through any back-edges.
 *
 * Back-edges are excluded to prevent infinite loops on examples like:
 * ```
 * while(true) { ++n; }
 * ```
 * which, when used in `localFlowStepRec`, would create infinite loop that continuously
 * increments the `delta` parameter.
 */
private predicate localFlowNotIncrStep(DataFlow::Node n1, DataFlow::Node n2) {
  not localFlowIncrStep(n1, n2, _) and
  DataFlow::localFlowStep(n1, n2) and
  not n1 = n2.(DataFlow::SsaPhiNode).getAnInput(true)
}

private predicate localFlowToExprStep(DataFlow::Node n1, DataFlow::Node n2) {
  not exists([n1.asExpr(), n1.asIndirectExpr()]) and
  localFlowNotIncrStep(n1, n2)
}

/** Holds if `mid2 + delta` may be equal to `n1`. */
private predicate localFlowStepRec0(DataFlow::Node n1, DataFlow::Node mid2, int delta) {
  exists(DataFlow::Node mid1, int d1, int d2 |
    // Or we take a number of steps that adds `d1` to the pointer
    localFlowStepRec(n1, mid1, d1) and
    // followed by a step that adds `d2` to the pointer
    localFlowIncrStep(mid1, mid2, d2) and
    delta = d1 + d2
  )
}

/** Holds if `n2 + delta` may be equal to `n1`. */
private predicate localFlowStepRec(DataFlow::Node n1, DataFlow::Node n2, int delta) {
  // Either we take one or more steps that doesn't modify the size of the buffer
  localFlowNotIncrStep+(n1, n2) and
  delta = 0
  or
  exists(DataFlow::Node mid2 |
    // Or we step from `n1` to `mid2 + delta`
    localFlowStepRec0(n1, mid2, delta) and
    // and finally to the next `ExprNode`.
    localFlowToExprStep*(mid2, n2)
  )
}

/**
 * Holds if `e2` is an expression that is derived from `e1` such that if `e1[n]` is a
 * well-defined expression for some number `n`, then `e2[n + delta]` is also a well-defined
 * expression.
 */
private predicate step(Expr e1, Expr e2, int delta) {
  exists(Variable bufferVar, Class parentClass, VariableAccess parentPtr, int bufferSize |
    e1 = parentPtr
  |
    bufferVar = e2.(VariableAccess).getTarget() and
    // buffer is the parentPtr->bufferVar of a 'variable size struct'
    memberMayBeVarSize(parentClass, bufferVar) and
    parentPtr = e2.(VariableAccess).getQualifier() and
    parentPtr.getTarget().getUnspecifiedType().(PointerType).getBaseType() = parentClass and
    (
      if exists(bufferVar.getType().getSize())
      then bufferSize = bufferVar.getType().getSize()
      else bufferSize = 0
    ) and
    delta = bufferSize - parentClass.getSize()
  )
  or
  exists(boolean isIndirect |
    localFlowStepRec(exprNode(e1, isIndirect), exprNode(e2, isIndirect), delta)
  )
}

/**
 * Get the size in bytes of the buffer pointed to by an expression (if this can be determined).
 */
int getBufferSize(Expr bufferExpr, Element why) {
  result = isSource(bufferExpr, why)
  or
  exists(Expr e0, int delta, int size |
    size = getBufferSize(e0, why) and
    delta = unique(int cand | step(e0, bufferExpr, cand) | cand) and
    result = size + delta
  )
}
