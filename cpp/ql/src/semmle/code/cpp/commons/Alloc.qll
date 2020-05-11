import cpp
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.Deallocation

/**
 * A library routine that allocates memory.
 *
 * DEPRECATED: Use the `AllocationFunction` class instead of this predicate.
 */
deprecated predicate allocationFunction(Function f) { f instanceof AllocationFunction }

/**
 * A call to a library routine that allocates memory.
 *
 * DEPRECATED: Use `AllocationExpr` instead (this also includes `new` expressions).
 */
deprecated predicate allocationCall(FunctionCall fc) { fc instanceof AllocationExpr }

/**
 * A library routine that frees memory.
 */
predicate freeFunction(Function f, int argNum) { argNum = f.(DeallocationFunction).getFreedArg() }

/**
 * A call to a library routine that frees memory.
 *
 * DEPRECATED: Use `DeallocationExpr` instead (this also includes `delete` expressions).
 */
predicate freeCall(FunctionCall fc, Expr arg) { arg = fc.(DeallocationExpr).getFreedExpr() }

/**
 * Is e some kind of allocation or deallocation (`new`, `alloc`, `realloc`, `delete`, `free` etc)?
 */
predicate isMemoryManagementExpr(Expr e) { isAllocationExpr(e) or e instanceof DeallocationExpr }

/**
 * Is e an allocation from stdlib.h (`malloc`, `realloc` etc)?
 *
 * DEPRECATED: Use `AllocationExpr` instead (this also includes `new` expressions).
 */
deprecated predicate isStdLibAllocationExpr(Expr e) { allocationCall(e) }

/**
 * Is e some kind of allocation (`new`, `alloc`, `realloc` etc)?
 */
predicate isAllocationExpr(Expr e) {
  e.(FunctionCall) instanceof AllocationExpr
  or
  e = any(NewOrNewArrayExpr new | not exists(new.getPlacementPointer()))
}

/**
 * Is e some kind of allocation (`new`, `alloc`, `realloc` etc) with a fixed size?
 *
 * DEPRECATED: Use `AllocationExpr.getSizeBytes()` instead.
 */
deprecated predicate isFixedSizeAllocationExpr(Expr allocExpr, int size) {
  size = allocExpr.(AllocationExpr).getSizeBytes()
}

/**
 * Is e some kind of deallocation (`delete`, `free`, `realloc` etc)?
 *
 * DEPRECATED: Use `DeallocationExpr` instead.
 */
deprecated predicate isDeallocationExpr(Expr e) { e instanceof DeallocationExpr }
