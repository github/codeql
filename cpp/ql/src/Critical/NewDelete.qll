/**
 * Provides predicates for associating new/malloc calls with delete/free.
 */
import cpp
import semmle.code.cpp.controlflow.SSA

/**
 * Holds if `alloc` is a use of `malloc` or `new`.  `kind` is
 * a string describing the type of the allocation.
 */
predicate allocExpr(Expr alloc, string kind) {
  isAllocationExpr(alloc) and
  (
    (
      alloc instanceof FunctionCall and
      kind = "malloc"
    ) or (
      alloc instanceof NewExpr and
      kind = "new" and

      // exclude placement new and custom overloads as they
      // may not conform to assumptions
      not alloc.(NewExpr).getAllocatorCall().getTarget().getNumberOfParameters() > 1
    ) or (
      alloc instanceof NewArrayExpr and
      kind = "new[]" and

      // exclude placement new and custom overloads as they
      // may not conform to assumptions
      not alloc.(NewArrayExpr).getAllocatorCall().getTarget().getNumberOfParameters() > 1
    )
  )
}

/**
 * Holds if `alloc` is a use of `malloc` or `new`, or a function
 * wrapping one of those.  `kind` is a string describing the type
 * of the allocation.
 */
predicate allocExprOrIndirect(Expr alloc, string kind) {
  // direct alloc
  allocExpr(alloc, kind) or

  exists(ReturnStmt rtn |
    // indirect alloc via function call
    alloc.(FunctionCall).getTarget() = rtn.getEnclosingFunction() and
    (
      allocExprOrIndirect(rtn.getExpr(), kind) or
      allocReaches(rtn.getExpr(), _, kind)
    )
  )
}

/**
 * Holds if `v` is a non-local variable which is assigned with
 * memory allocation `alloc` only (it may also be assigned with
 * NULL).  `kind` is a string describing the type of that allocation.
 */
private predicate allocReachesVariable(Variable v, Expr alloc, string kind) {
  exists(Expr mid |
    allocReaches(mid, alloc, kind) and
    v.getAnAssignedValue() = mid and
    not v instanceof LocalScopeVariable and
    count(Expr e |
      v.getAnAssignedValue() = e and
      not e.getValue().toInt() = 0
    ) = 1
  )
}

/**
 * Holds if `e` is an expression which may evaluate to the
 * result of a previous memory allocation `alloc`.  `kind` is a
 * string describing the type of that allocation.
 */
predicate allocReaches(Expr e, Expr alloc, string kind) {
  (
    // alloc
    allocExprOrIndirect(alloc, kind) and
    e = alloc
  ) or exists(SsaDefinition def, LocalScopeVariable v |
    // alloc via SSA
    allocReaches(def.getAnUltimateDefiningValue(v), alloc, kind) and
    e = def.getAUse(v)
  ) or exists(Variable v |
    // alloc via a singly assigned global
    allocReachesVariable(v, alloc, kind) and
    e.(VariableAccess).getTarget() = v
  )
}

/**
 * Holds if `free` is a use of free or delete.  `freed` is the
 * expression that is freed / deleted and `kind` is a string
 * describing the type of that free or delete.
 */
predicate freeExpr(Expr free, Expr freed, string kind) {
  (
    freeCall(free, freed) and
    kind = "free"
  ) or (
    free.(DeleteExpr).getExpr() = freed and
    kind = "delete"
  ) or (
    free.(DeleteArrayExpr).getExpr() = freed and
    kind = "delete[]"
  )
}

/**
 * Holds if `free` is a use of free or delete, or a function
 * wrapping one of those.  `freed` is the expression that is
 * freed / deleted and `kind` is a string describing the type
 * of that free or delete.
 */
predicate freeExprOrIndirect(Expr free, Expr freed, string kind) {
  // direct free
  freeExpr(free, freed, kind) or

  // indirect free via function call
  exists(Expr internalFree, Expr internalFreed, int arg |
    freeExprOrIndirect(internalFree, internalFreed, kind) and
    free.(FunctionCall).getTarget().getParameter(arg) = internalFreed.(VariableAccess).getTarget() and
    free.(FunctionCall).getArgument(arg) = freed
  )
}
