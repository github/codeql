/**
 * @name Non-synchronized override of synchronized method
 * @description If a synchronized method is overridden in a subclass, and the overriding method is
 *              not synchronized, the thread-safety of the subclass may be broken.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/non-sync-override
 * @tags reliability
 *       correctness
 *       concurrency
 *       language-features
 *       external/cwe/cwe-820
 */

import java

/**
 * Check whether expression `e` is a call to method `target` of the form
 * `super.m(x, y, z)`, possibly wrapped in one or more casts and/or parentheses.
 */
predicate delegatingSuperCall(Expr e, Method target) {
  exists(MethodCall call | call = e |
    call.getQualifier() instanceof SuperAccess and
    call.getCallee() = target and
    forall(Expr arg | arg = call.getAnArgument() | arg instanceof VarAccess)
  )
  or
  delegatingSuperCall(e.(CastingExpr).getExpr(), target)
}

/**
 * Check whether method `sub` is a trivial override of method `sup` that simply
 * delegates to `sup`.
 */
predicate delegatingOverride(Method sub, Method sup) {
  exists(Stmt stmt |
    // The body of `sub` consists of a single statement...
    stmt = sub.getBody().(SingletonBlock).getStmt() and
    (
      // ...that is either a delegating call to `sup` (with a possible cast)...
      delegatingSuperCall(stmt.(ExprStmt).getExpr(), sup)
      or
      // ...or a `return` statement containing such a call.
      delegatingSuperCall(stmt.(ReturnStmt).getResult(), sup)
    )
  )
}

from Method sub, Method sup, Class supSrc
where
  sub.overrides(sup) and
  sub.fromSource() and
  sup.isSynchronized() and
  not sub.isSynchronized() and
  not delegatingOverride(sub, sup) and
  supSrc = sup.getDeclaringType().getSourceDeclaration()
select sub,
  "Method '" + sub.getName() + "' overrides a synchronized method in $@ but is not synchronized.",
  supSrc, supSrc.getQualifiedName()
