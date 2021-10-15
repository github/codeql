/**
 * @name Potential use after free
 * @description An allocated memory block is used after it has been freed. Behavior in such cases is undefined and can cause memory corruption.
 * @kind problem
 * @id cpp/use-after-free
 * @problem.severity warning
 * @security-severity 9.3
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 */

import cpp
import semmle.code.cpp.controlflow.StackVariableReachability

/** `e` is an expression that frees the memory pointed to by `v`. */
predicate isFreeExpr(Expr e, StackVariable v) {
  exists(VariableAccess va | va.getTarget() = v |
    exists(FunctionCall fc | fc = e |
      fc.getTarget().hasGlobalOrStdName("free") and
      va = fc.getArgument(0)
    )
    or
    e.(DeleteExpr).getExpr() = va
    or
    e.(DeleteArrayExpr).getExpr() = va
  )
}

/** `e` is an expression that (may) dereference `v`. */
predicate isDerefExpr(Expr e, StackVariable v) {
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
predicate isDerefByCallExpr(Call c, int i, VariableAccess va, StackVariable v) {
  v.getAnAccess() = va and
  va = c.getAnArgumentSubExpr(i) and
  not c.passesByReference(i, va) and
  (c.getTarget().hasEntryPoint() implies isDerefExpr(_, c.getTarget().getParameter(i)))
}

class UseAfterFreeReachability extends StackVariableReachability {
  UseAfterFreeReachability() { this = "UseAfterFree" }

  override predicate isSource(ControlFlowNode node, StackVariable v) { isFreeExpr(node, v) }

  override predicate isSink(ControlFlowNode node, StackVariable v) { isDerefExpr(node, v) }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    definitionBarrier(v, node) or
    isFreeExpr(node, v)
  }
}

from UseAfterFreeReachability r, StackVariable v, Expr free, Expr e
where r.reaches(free, v, e)
select e, "Memory pointed to by '" + v.getName().toString() + "' may have been previously freed $@",
  free, "here"
