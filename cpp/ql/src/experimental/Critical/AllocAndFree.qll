import cpp
import Critical.MemoryFreed

predicate mayCallFunction(Expr call, Function f) {
    call.(FunctionCall).getTarget() = f or
    call.(VariableCall).getVariable().getAnAssignedValue().getAChild*().(FunctionAccess).getTarget() =
      f
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
  
  predicate allocationDefinition(StackVariable v, ControlFlowNode def) {
    exists(Expr expr | exprDefinition(v, def, expr) and allocCallOrIndirect(expr))
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
  