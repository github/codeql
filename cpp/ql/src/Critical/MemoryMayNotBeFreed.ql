/**
 * @name Memory may not be freed
 * @description A function may return before freeing memory that was allocated in the function. Freeing all memory allocated in the function before returning ties the lifetime of the memory blocks to that of the function call, making it easier to avoid and detect memory leaks.
 * @kind problem
 * @id cpp/memory-may-not-be-freed
 * @problem.severity warning
 * @security-severity 7.5
 * @tags efficiency
 *       security
 *       external/cwe/cwe-401
 */

import MemoryFreed
import semmle.code.cpp.controlflow.StackVariableReachability

/**
 * 'call' is either a direct call to f, or a possible call to f
 * via a function pointer.
 */
predicate mayCallFunction(Expr call, Function f) {
  call.(FunctionCall).getTarget() = f or
  call.(VariableCall).getVariable().getAnAssignedValue().getAChild*().(FunctionAccess).getTarget() =
    f
}

predicate allocCallOrIndirect(Expr e) {
  // direct alloc call
  e.(AllocationExpr).requiresDealloc() and
  // We are only interested in alloc calls that are
  // actually freed somehow, as MemoryNeverFreed
  // will catch those that aren't.
  allocMayBeFreed(e)
  or
  exists(ReturnStmt rtn |
    // indirect alloc call
    mayCallFunction(e, rtn.getEnclosingFunction()) and
    (
      // return alloc
      allocCallOrIndirect(rtn.getExpr())
      or
      // return variable assigned with alloc
      exists(Variable v |
        v = rtn.getExpr().(VariableAccess).getTarget() and
        allocCallOrIndirect(v.getAnAssignedValue()) and
        not assignedToFieldOrGlobal(v, _)
      )
    )
  )
}

/**
 * The point at which a call to 'realloc' on 'v' has been verified to
 * succeed.  A failed realloc does *not* free the input pointer, which
 * can cause memory leaks.
 */
predicate verifiedRealloc(FunctionCall reallocCall, Variable v, ControlFlowNode verified) {
  reallocCall.(AllocationExpr).getReallocPtr() = v.getAnAccess() and
  (
    exists(Variable newV, ControlFlowNode node |
      // a realloc followed by a null check at 'node' (return the non-null
      // successor, i.e. where the realloc is confirmed to have succeeded)
      newV.getAnAssignedValue() = reallocCall and
      node.(AnalysedExpr).getNonNullSuccessor(newV) = verified and
      // note: this case uses naive flow logic (getAnAssignedValue).
      // special case: if the result of the 'realloc' is assigned to the
      // same variable, we don't descriminate properly between the old
      // and the new allocation; better to not consider this a free at
      // all in that case.
      newV != v
    )
    or
    // a realloc(ptr, 0), which always succeeds and frees
    // (return the realloc itself)
    reallocCall.(AllocationExpr).getReallocPtr().getValue() = "0" and
    verified = reallocCall
  )
}

predicate freeCallOrIndirect(ControlFlowNode n, Variable v) {
  // direct free call
  n.(DeallocationExpr).getFreedExpr() = v.getAnAccess() and
  not exists(n.(AllocationExpr).getReallocPtr())
  or
  // verified realloc call
  verifiedRealloc(_, v, n)
  or
  exists(FunctionCall midcall, Function mid, int arg |
    // indirect free call
    n.(Call).getArgument(arg) = v.getAnAccess() and
    mayCallFunction(n, mid) and
    midcall.getEnclosingFunction() = mid and
    freeCallOrIndirect(midcall, mid.getParameter(arg))
  )
}

predicate allocationDefinition(StackVariable v, ControlFlowNode def) {
  exists(Expr expr | exprDefinition(v, def, expr) and allocCallOrIndirect(expr))
}

class AllocVariableReachability extends StackVariableReachabilityWithReassignment {
  AllocVariableReachability() { this = "AllocVariableReachability" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable v) {
    allocationDefinition(v, node)
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable v) {
    // node may be used in allocationReaches
    exists(node.(AnalysedExpr).getNullSuccessor(v)) or
    freeCallOrIndirect(node, v) or
    assignedToFieldOrGlobal(v, node) or
    // node may be used directly in query
    v.getFunction() = node.(ReturnStmt).getEnclosingFunction()
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) { definitionBarrier(v, node) }
}

/**
 * The value from allocation `def` is still held in Variable `v` upon entering `node`.
 */
predicate allocatedVariableReaches(StackVariable v, ControlFlowNode def, ControlFlowNode node) {
  exists(AllocVariableReachability r |
    // reachability
    r.reachesTo(def, _, node, v)
    or
    // accept def node itself
    r.isSource(def, v) and
    node = def
  )
}

class AllocReachability extends StackVariableReachabilityExt {
  AllocReachability() { this = "AllocReachability" }

  override predicate isSource(ControlFlowNode node, StackVariable v) {
    allocationDefinition(v, node)
  }

  override predicate isSink(ControlFlowNode node, StackVariable v) {
    v.getFunction() = node.(ReturnStmt).getEnclosingFunction()
  }

  override predicate isBarrier(
    ControlFlowNode source, ControlFlowNode node, ControlFlowNode next, StackVariable v
  ) {
    isSource(source, v) and
    next = node.getASuccessor() and
    // the memory (stored in any variable `v0`) allocated at `source` is freed or
    // assigned to a global at node, or NULL checked on the edge node -> next.
    exists(StackVariable v0 | allocatedVariableReaches(v0, source, node) |
      node.(AnalysedExpr).getNullSuccessor(v0) = next or
      freeCallOrIndirect(node, v0) or
      assignedToFieldOrGlobal(v0, node)
    )
  }
}

/**
 * The value returned by allocation `def` has not been freed, confirmed to be null,
 * or potentially leaked globally upon reaching `node`  (regardless of what variable
 * it's still held in, if any).
 */
predicate allocationReaches(ControlFlowNode def, ControlFlowNode node) {
  exists(AllocReachability r | r.reaches(def, _, node))
}

predicate assignedToFieldOrGlobal(StackVariable v, Expr e) {
  // assigned to anything except a StackVariable
  // (typically a field or global, but for example also *ptr = v)
  e.(Assignment).getRValue() = v.getAnAccess() and
  not e.(Assignment).getLValue().(VariableAccess).getTarget() instanceof StackVariable
  or
  exists(Expr midExpr, Function mid, int arg |
    // indirect assignment
    e.(FunctionCall).getArgument(arg) = v.getAnAccess() and
    mayCallFunction(e, mid) and
    midExpr.getEnclosingFunction() = mid and
    assignedToFieldOrGlobal(mid.getParameter(arg), midExpr)
  )
  or
  // assigned to a field via constructor field initializer
  e.(ConstructorFieldInit).getExpr() = v.getAnAccess()
}

from ControlFlowNode def, ReturnStmt ret
where
  allocationReaches(def, ret) and
  not exists(StackVariable v |
    allocatedVariableReaches(v, def, ret) and
    ret.getAChild*() = v.getAnAccess()
  )
select def, "The memory allocated here may not be released at $@.", ret, "this exit point"
