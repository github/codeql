/**
 * @name Contradictory type checks
 * @description Contradictory dynamic type checks in `instanceof` expressions
 *              and casts may cause dead code or even runtime errors, and usually
 *              indicate a logic error.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/contradictory-type-checks
 * @tags correctness
 *       logic
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.SSA

/** `ioe` is of the form `va instanceof t`. */
predicate instanceOfCheck(InstanceOfExpr ioe, VarAccess va, RefType t) {
  ioe.getExpr() = va and
  ioe.getCheckedType().getSourceDeclaration() = t
}

/** Expression `e` assumes that `va` could be of type `t`. */
predicate requiresInstanceOf(Expr e, VarAccess va, RefType t) {
  // `e` is a cast of the form `(t)va`
  e.(CastExpr).getExpr() = va and t = e.getType().(RefType).getSourceDeclaration()
  or
  // `e` is `va instanceof t`
  instanceOfCheck(e, va, t)
}

/**
 * `e` assumes that `v` could be of type `t`, but `cond`, in fact, ensures that
 * `v` is not of type `sup`, which is a supertype of `t`.
 */
predicate contradictoryTypeCheck(Expr e, Variable v, RefType t, RefType sup, Expr cond) {
  exists(SsaVariable ssa |
    ssa.getSourceVariable().getVariable() = v and
    requiresInstanceOf(e, ssa.getAUse(), t) and
    sup = t.getAnAncestor() and
    instanceOfCheck(cond, ssa.getAUse(), sup) and
    cond.(Guard).controls(e.getBasicBlock(), false) and
    not t instanceof ErrorType and
    not sup instanceof ErrorType
  )
}

from Expr e, Variable v, RefType t, RefType sup, Expr cond
where contradictoryTypeCheck(e, v, t, sup, cond)
select e, "This access of $@ cannot be of type $@, since $@ ensures that it is not of type $@.", v,
  v.getName(), t, t.getName(), cond, "this expression", sup, sup.getName()
