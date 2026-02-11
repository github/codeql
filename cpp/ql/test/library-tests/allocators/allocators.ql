import cpp
import semmle.code.cpp.models.implementations.Allocation
import semmle.code.cpp.Print

query predicate newExprs(
  NewExpr expr, string type, string sig, int size, int alignment, string form, string placement
) {
  exists(Function allocator, Type allocatedType |
    expr.getAllocator() = allocator and
    sig = getIdentityString(allocator) and
    allocatedType = expr.getAllocatedType() and
    type = allocatedType.toString() and
    size = allocatedType.getSize() and
    alignment = allocatedType.getAlignment() and
    (if expr.hasAlignedAllocation() then form = "aligned" else form = "") and
    if exists(expr.getPlacementPointer())
    then placement = expr.getPlacementPointer().toString()
    else placement = ""
  )
}

query predicate newArrayExprs(
  NewArrayExpr expr, string t1, string t2, string sig, int size, int alignment, string form,
  string extents, string placement
) {
  exists(Function allocator, Type arrayType, Type elementType |
    expr.getAllocator() = allocator and
    sig = getIdentityString(allocator) and
    arrayType = expr.getAllocatedType() and
    t1 = arrayType.toString() and
    elementType = expr.getAllocatedElementType() and
    t2 = elementType.toString() and
    size = elementType.getSize() and
    alignment = elementType.getAlignment() and
    (if expr.hasAlignedAllocation() then form = "aligned" else form = "") and
    extents = concat(Expr e | e = expr.getExtent() | e.toString(), ", ") and
    if exists(expr.getPlacementPointer())
    then placement = expr.getPlacementPointer().toString()
    else placement = ""
  )
}

query predicate newExprDeallocators(
  NewExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function deallocator, Type allocatedType |
    expr.getDeallocator() = deallocator and
    sig = getIdentityString(deallocator) and
    allocatedType = expr.getAllocatedType() and
    type = allocatedType.toString() and
    size = allocatedType.getSize() and
    alignment = allocatedType.getAlignment() and
    exists(string sized, string aligned, string destroying |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      (if expr.isDestroyingDeleteDeallocation() then destroying = "destroying" else destroying = "") and
      form = sized + " " + aligned + " " + destroying
    )
  )
}

query predicate newArrayExprDeallocators(
  NewArrayExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function deallocator, Type elementType |
    expr.getDeallocator() = deallocator and
    sig = getIdentityString(deallocator) and
    elementType = expr.getAllocatedElementType() and
    type = elementType.toString() and
    size = elementType.getSize() and
    alignment = elementType.getAlignment() and
    exists(string sized, string aligned, string destroying |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      (if expr.isDestroyingDeleteDeallocation() then destroying = "destroying" else destroying = "") and
      form = sized + " " + aligned + " " + destroying
    )
  )
}

query predicate deleteExprs(
  DeleteExpr expr, string type, string sig, int size, int alignment, string form,
  boolean hasDeallocatorCall
) {
  exists(Function deallocator, Type deletedType |
    expr.getDeallocator() = deallocator and
    sig = getIdentityString(deallocator) and
    deletedType = expr.getDeletedObjectType() and
    type = deletedType.toString() and
    size = deletedType.getSize() and
    alignment = deletedType.getAlignment() and
    exists(string sized, string aligned, string destroying |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      (if expr.isDestroyingDeleteDeallocation() then destroying = "destroying" else destroying = "") and
      form = sized + " " + aligned + " " + destroying
    ) and
    if exists(expr.getDeallocatorCall())
    then hasDeallocatorCall = true
    else hasDeallocatorCall = false
  )
}

query predicate deleteArrayExprs(
  DeleteArrayExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function deallocator, Type elementType |
    expr.getDeallocator() = deallocator and
    sig = getIdentityString(deallocator) and
    elementType = expr.getDeletedElementType() and
    type = elementType.toString() and
    size = elementType.getSize() and
    alignment = elementType.getAlignment() and
    exists(string sized, string aligned, string destroying |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      (if expr.isDestroyingDeleteDeallocation() then destroying = "destroying" else destroying = "") and
      form = sized + " " + aligned + " " + destroying
    )
  )
}

string describeAllocationFunction(AllocationFunction f) {
  result = "getSizeArg = " + f.getSizeArg().toString()
  or
  result = "getSizeMult = " + f.getSizeMult().toString()
  or
  result = "getReallocPtrArg = " + f.getReallocPtrArg().toString()
  or
  f.requiresDealloc() and
  result = "requiresDealloc"
  or
  result =
    "getPlacementArgument = " + f.(OperatorNewAllocationFunction).getPlacementArgument().toString()
}

query predicate allocationFunctions(AllocationFunction f, string descr) {
  descr = concat(describeAllocationFunction(f), ", ")
}

string describeAllocationExpr(AllocationExpr e) {
  result = "getSizeExpr = " + e.getSizeExpr().toString()
  or
  result = "getSizeMult = " + e.getSizeMult().toString()
  or
  result = "getSizeBytes = " + e.getSizeBytes().toString()
  or
  result = "getReallocPtr = " + e.getReallocPtr().toString()
  or
  result = "getAllocatedElementType = " + e.getAllocatedElementType().toString()
  or
  e.requiresDealloc() and
  result = "requiresDealloc"
}

query predicate allocationExprs(AllocationExpr e, string descr) {
  descr = concat(describeAllocationExpr(e), ", ")
}

string describeDeallocationFunction(DeallocationFunction f) {
  result = "getFreedArg = " + f.getFreedArg().toString()
}

query predicate deallocationFunctions(DeallocationFunction f, string descr) {
  descr = concat(describeDeallocationFunction(f), ", ")
}

string describeDeallocationExpr(DeallocationExpr e) {
  result = "getFreedExpr = " + e.getFreedExpr().toString()
}

query predicate deallocationExprs(DeallocationExpr e, string descr) {
  descr = concat(describeDeallocationExpr(e), ", ")
}
