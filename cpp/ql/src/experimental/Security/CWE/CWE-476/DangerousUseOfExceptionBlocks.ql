/**
 * @name Dangerous use of exception blocks.
 * @description When clearing the data in the catch block, you must be sure that the memory was allocated before the exception.
 * @kind problem
 * @id cpp/dangerous-use-of-exception-blocks
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       experimental
 *       external/cwe/cwe-476
 *       external/cwe/cwe-415
 */

import cpp

/** Holds if `vr` may be released in the `try` block associated with `cb`, or in a `catch` block prior to `cb`. */
pragma[inline]
predicate doubleCallDelete(BlockStmt b, CatchAnyBlock cb, Variable vr) {
  // Search for exceptions after freeing memory.
  exists(Expr e1 |
    // `e1` is a delete of `vr`
    (
      e1 = vr.getAnAccess().getEnclosingStmt().(ExprStmt).getExpr().(DeleteArrayExpr) or
      e1 = vr.getAnAccess().getEnclosingStmt().(ExprStmt).getExpr().(DeleteExpr)
    ) and
    e1.getEnclosingFunction() = cb.getEnclosingFunction() and
    // there is no assignment `vr = 0` in the `try` block after `e1`
    not exists(AssignExpr ae |
      ae.getLValue().(VariableAccess).getTarget() = vr and
      ae.getRValue().getValue() = "0" and
      e1.getASuccessor+() = ae and
      ae.getEnclosingStmt().getParentStmt*() = b
    ) and
    // `e2` is a `throw` (or a function call that may throw) that occurs in the `try` or `catch` block after `e1`
    exists(Expr e2, ThrowExpr th |
      (
        e2 = th or
        e2 = th.getEnclosingFunction().getACallToThisFunction()
      ) and
      e2.getEnclosingStmt().getParentStmt*() = b and
      e1.getASuccessor+() = e2
    ) and
    e1.getEnclosingStmt().getParentStmt*() = b and
    (
      // Search for a situation where there is a release in the block of `try`.
      b = cb.getTryStmt().getStmt()
      or
      // Search for a situation when there is a higher catch block that also frees memory.
      exists(b.(CatchBlock).getParameter())
    ) and
    // Exclude the presence of a check in catch block.
    not exists(IfStmt ifst | ifst.getEnclosingStmt().getParentStmt*() = cb.getAStmt())
  )
}

/** Holds if an exception can be thrown before the memory is allocated, and when the exception is handled, an attempt is made to access unallocated memory in the catch block. */
pragma[inline]
predicate pointerDereference(CatchAnyBlock cb, Variable vr, Variable vro) {
  // Search exceptions before allocating memory.
  exists(Expr e0, Expr e1 |
    (
      // `e0` is a `new` expression (or equivalent function call) assigned to `vro`
      exists(AssignExpr ase |
        ase = vro.getAnAccess().getEnclosingStmt().(ExprStmt).getExpr() and
        (
          e0 = ase.getRValue().(NewOrNewArrayExpr) or
          e0 = ase.getRValue().(NewOrNewArrayExpr).getEnclosingFunction().getACallToThisFunction()
        ) and
        vro = ase.getLValue().(VariableAccess).getTarget()
      )
      or
      // `e0` is a `new` expression (or equivalent function call) assigned to the array element `vro`
      exists(AssignExpr ase |
        ase = vro.getAnAccess().(Qualifier).getEnclosingStmt().(ExprStmt).getExpr() and
        (
          e0 = ase.getRValue().(NewOrNewArrayExpr) or
          e0 = ase.getRValue().(NewOrNewArrayExpr).getEnclosingFunction().getACallToThisFunction()
        ) and
        not ase.getLValue() instanceof VariableAccess and
        vro = ase.getLValue().getAPredecessor().(VariableAccess).getTarget()
      )
    ) and
    // `e1` is a `new` expression (or equivalent function call) assigned to `vr`
    exists(AssignExpr ase |
      ase = vr.getAnAccess().getEnclosingStmt().(ExprStmt).getExpr() and
      (
        e1 = ase.getRValue().(NewOrNewArrayExpr) or
        e1 = ase.getRValue().(NewOrNewArrayExpr).getEnclosingFunction().getACallToThisFunction()
      ) and
      vr = ase.getLValue().(VariableAccess).getTarget()
    ) and
    e0.getASuccessor*() = e1 and
    e0.getEnclosingStmt().getParentStmt*() = cb.getTryStmt().getStmt() and
    e1.getEnclosingStmt().getParentStmt*() = cb.getTryStmt().getStmt() and
    // `e2` is a `throw` (or a function call that may throw) that occurs in the `try` block before `e0`
    exists(Expr e2, ThrowExpr th |
      (
        e2 = th or
        e2 = th.getEnclosingFunction().getACallToThisFunction()
      ) and
      e2.getEnclosingStmt().getParentStmt*() = cb.getTryStmt().getStmt() and
      e2.getASuccessor+() = e0
    )
  ) and
  // We exclude checking the value of a variable or its parent in the catch block.
  not exists(IfStmt ifst |
    ifst.getEnclosingStmt().getParentStmt*() = cb.getAStmt() and
    (
      ifst.getCondition().getAChild*().(VariableAccess).getTarget() = vr or
      ifst.getCondition().getAChild*().(VariableAccess).getTarget() = vro
    )
  )
}

/** Holds if `vro` may be released in the `catch`. */
pragma[inline]
predicate newThrowDelete(CatchAnyBlock cb, Variable vro) {
  exists(Expr e0, AssignExpr ase, NewOrNewArrayExpr nae |
    ase = vro.getAnAccess().getEnclosingStmt().(ExprStmt).getExpr() and
    nae = ase.getRValue() and
    not nae.getAChild*().toString() = "nothrow" and
    (
      e0 = nae or
      e0 = nae.getEnclosingFunction().getACallToThisFunction()
    ) and
    vro = ase.getLValue().(VariableAccess).getTarget() and
    e0.getEnclosingStmt().getParentStmt*() = cb.getTryStmt().getStmt() and
    not exists(AssignExpr ase1 |
      vro = ase1.getLValue().(VariableAccess).getTarget() and
      ase1.getRValue().getValue() = "0" and
      ase1.getASuccessor*() = e0
    )
  ) and
  not exists(Initializer it |
    vro.getInitializer() = it and
    it.getExpr().getValue() = "0"
  ) and
  not exists(ConstructorFieldInit ci | vro = ci.getTarget())
}

from CatchAnyBlock cb, string msg
where
  exists(Variable vr, Variable vro, Expr exp |
    exp.getEnclosingStmt().getParentStmt*() = cb and
    exists(VariableAccess va |
      (
        (
          va = exp.(DeleteArrayExpr).getExpr().getAPredecessor+().(Qualifier) or
          va = exp.(DeleteArrayExpr).getExpr().getAPredecessor+()
        ) and
        vr = exp.(DeleteArrayExpr).getExpr().(VariableAccess).getTarget()
        or
        (
          va = exp.(DeleteExpr).getExpr().getAPredecessor+().(Qualifier) or
          va = exp.(DeleteExpr).getExpr().getAPredecessor+()
        ) and
        vr = exp.(DeleteExpr).getExpr().(VariableAccess).getTarget()
      ) and
      va.getEnclosingStmt() = exp.getEnclosingStmt() and
      vro = va.getTarget() and
      vr != vro
    ) and
    pointerDereference(cb, vr, vro) and
    msg =
      "it is possible to dereference a pointer when accessing a " + vr.getName() +
        ", since it is possible to throw an exception before the memory for the " + vro.getName() +
        " is allocated"
  )
  or
  exists(Expr exp, Variable vr |
    (
      exp.(DeleteExpr).getEnclosingStmt().getParentStmt*() = cb and
      vr = exp.(DeleteExpr).getExpr().(VariableAccess).getTarget()
      or
      exp.(DeleteArrayExpr).getEnclosingStmt().getParentStmt*() = cb and
      vr = exp.(DeleteArrayExpr).getExpr().(VariableAccess).getTarget()
    ) and
    doubleCallDelete(_, cb, vr) and
    msg =
      "This allocation may have been released in the try block or a previous catch block." +
        vr.getName()
  )
  or
  exists(Variable vro, Expr exp |
    exp.getEnclosingStmt().getParentStmt*() = cb and
    exists(VariableAccess va |
      (
        va = exp.(DeleteArrayExpr).getExpr() or
        va = exp.(DeleteExpr).getExpr()
      ) and
      va.getEnclosingStmt() = exp.getEnclosingStmt() and
      vro = va.getTarget()
    ) and
    newThrowDelete(cb, vro) and
    msg =
      "If the allocation in the try block fails, then an unallocated pointer " + vro.getName() +
        " will be freed in the catch block."
  )
select cb, msg
