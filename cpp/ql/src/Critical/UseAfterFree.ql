/**
 * @name Potential use after free
 * @description An allocated memory block is used after it has been freed. Behavior in such cases is undefined and can cause memory corruption.
 * @kind problem
 * @id cpp/use-after-free
 * @problem.severity warning
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 */

import cpp
import semmle.code.cpp.controlflow.LocalScopeVariableReachability

/** `e` is an expression that frees the memory pointed to by `v`. */
predicate isFreeExpr(Expr e, LocalScopeVariable v) {
  exists(VariableAccess va | va.getTarget() = v |
    exists(FunctionCall fc | fc = e |
      fc.getTarget().hasGlobalName("free") and
      va = fc.getArgument(0)
    )
    or
    e.(DeleteExpr).getExpr() = va
    or
    e.(DeleteArrayExpr).getExpr() = va
  )
}

/** `e` is an expression that (may) dereference `v`. */
predicate isDerefExpr(Expr e, LocalScopeVariable v) {
  v.getAnAccess() = e and dereferenced(e)
  or
  isDerefByCallExpr(_, _, e, v)
}

/**
 * `va` is passed by value as (part of) the `i`th argument in
 * call `c`. The target function is either a library function
 * or a source code function that dereferences the relevant
 * parameter.
 */
predicate isDerefByCallExpr(Call c, int i, VariableAccess va, LocalScopeVariable v) {
  v.getAnAccess() = va and
  va = c.getAnArgumentSubExpr(i) and
  not c.passesByReference(i, va) and
  (c.getTarget().hasEntryPoint() implies isDerefExpr(_, c.getTarget().getParameter(i)))
}

class UseAfterFreeReachability extends LocalScopeVariableReachability {
  UseAfterFreeReachability() { this = "UseAfterFree" }

  override predicate isSource(ControlFlowNode node, LocalScopeVariable v) { isFreeExpr(node, v) }

  override predicate isSink(ControlFlowNode node, LocalScopeVariable v) { isDerefExpr(node, v) }

  override predicate isBarrier(ControlFlowNode node, LocalScopeVariable v) {
    definitionBarrier(v, node) or
    isFreeExpr(node, v)
  }
}

from UseAfterFreeReachability r, LocalScopeVariable v, Expr free, Expr e
where r.reaches(free, v, e)
select e, "Memory pointed to by '" + v.getName().toString() + "' may have been previously freed $@",
  free, "here"
