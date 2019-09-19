import default

query predicate newExprs(NewExpr expr, string type, string sig, int size, int alignment, string form) {
  exists(Function allocator, Type allocatedType |
    expr.getAllocator() = allocator and
    sig = allocator.getFullSignature() and
    allocatedType = expr.getAllocatedType() and
    type = allocatedType.toString() and
    size = allocatedType.getSize() and
    alignment = allocatedType.getAlignment() and
    if expr.hasAlignedAllocation() then form = "aligned" else form = ""
  )
}

query predicate newArrayExprs(
  NewArrayExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function allocator, Type elementType |
    expr.getAllocator() = allocator and
    sig = allocator.getFullSignature() and
    elementType = expr.getAllocatedElementType() and
    type = elementType.toString() and
    size = elementType.getSize() and
    alignment = elementType.getAlignment() and
    if expr.hasAlignedAllocation() then form = "aligned" else form = ""
  )
}

query predicate newExprDeallocators(
  NewExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function deallocator, Type allocatedType |
    expr.getDeallocator() = deallocator and
    sig = deallocator.getFullSignature() and
    allocatedType = expr.getAllocatedType() and
    type = allocatedType.toString() and
    size = allocatedType.getSize() and
    alignment = allocatedType.getAlignment() and
    exists(string sized, string aligned |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      form = sized + " " + aligned
    )
  )
}

query predicate newArrayExprDeallocators(
  NewArrayExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function deallocator, Type elementType |
    expr.getDeallocator() = deallocator and
    sig = deallocator.getFullSignature() and
    elementType = expr.getAllocatedElementType() and
    type = elementType.toString() and
    size = elementType.getSize() and
    alignment = elementType.getAlignment() and
    exists(string sized, string aligned |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      form = sized + " " + aligned
    )
  )
}

query predicate deleteExprs(
  DeleteExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function deallocator, Type deletedType |
    expr.getDeallocator() = deallocator and
    sig = deallocator.getFullSignature() and
    deletedType = expr.getDeletedObjectType() and
    type = deletedType.toString() and
    size = deletedType.getSize() and
    alignment = deletedType.getAlignment() and
    exists(string sized, string aligned |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      form = sized + " " + aligned
    )
  )
}

query predicate deleteArrayExprs(
  DeleteArrayExpr expr, string type, string sig, int size, int alignment, string form
) {
  exists(Function deallocator, Type elementType |
    expr.getDeallocator() = deallocator and
    sig = deallocator.getFullSignature() and
    elementType = expr.getDeletedElementType() and
    type = elementType.toString() and
    size = elementType.getSize() and
    alignment = elementType.getAlignment() and
    exists(string sized, string aligned |
      (if expr.hasAlignedDeallocation() then aligned = "aligned" else aligned = "") and
      (if expr.hasSizedDeallocation() then sized = "sized" else sized = "") and
      form = sized + " " + aligned
    )
  )
}
