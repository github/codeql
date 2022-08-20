import cpp
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.Deallocation

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
 * Is e some kind of allocation (`new`, `alloc`, `realloc` etc)?
 */
predicate isAllocationExpr(Expr e) {
  e.(FunctionCall) instanceof AllocationExpr
  or
  e = any(NewOrNewArrayExpr new | not exists(new.getPlacementPointer()))
}
