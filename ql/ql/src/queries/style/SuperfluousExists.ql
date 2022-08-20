/**
 * @name Superfluous 'exists' conjunct.
 * @description Writing 'exists(x)' when the existence of X is implied by another conjunct is bad practice.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id ql/superfluous-exists
 * @tags maintainability
 */

import ql
import codeql.GlobalValueNumbering

/**
 * Gets an operand of this conjunction (we need the restriction
 * to `Conjunction` to get the correct transitive closure).
 */
Formula getAConjOperand(Conjunction conj) { result = conj.getAnOperand() }

/** A conjunction that is not a operand of another conjunction. */
class TopLevelConjunction extends Conjunction {
  TopLevelConjunction() { not this = getAConjOperand(_) }

  /** Gets a formula within this conjunction that is not itself a conjunction. */
  Formula getAnAtom() {
    not result instanceof Conjunction and
    result = getAConjOperand*(this)
  }
}

/**
 * Holds if the existence of `e` implies the existence of `vn`. For instance, the existence of
 * `1 + x` implies the existence of a value number `vn` such that `vn.getAnExpr() = x`.
 */
predicate exprImpliesExists(ValueNumber vn, Expr e) {
  vn.getAnExpr() = e
  or
  exprImpliesExists(vn, e.(BinOpExpr).getAnOperand())
  or
  exprImpliesExists(vn, e.(InlineCast).getBase())
  or
  exprImpliesExists(vn, e.(PredicateCall).getAnArgument())
  or
  exprImpliesExists(vn, [e.(MemberCall).getAnArgument(), e.(MemberCall).getBase()])
  or
  exprImpliesExists(vn, e.(UnaryExpr).getOperand())
  or
  exprImpliesExists(vn, e.(ExprAnnotation).getExpression())
  or
  forex(Formula child | child = e.(Set).getAnElement() | exprImpliesExists(vn, child))
  or
  exprImpliesExists(vn, e.(AsExpr).getInnerExpr())
  or
  exists(ExprAggregate agg |
    agg = e and
    agg.getKind().matches(["strict%", "unique"]) and
    exprImpliesExists(vn, agg.getExpr(0))
  )
}

/**
 * Holds if the satisfiability of `f` implies the existence of `vn`. For instance, if `x.foo()` is
 * satisfied, the value number `vn` such that `vn.getAnExpr() = x` exists.
 */
predicate formulaImpliesExists(ValueNumber vn, Formula f) {
  forex(Formula child | child = f.(Disjunction).getAnOperand() | formulaImpliesExists(vn, child))
  or
  formulaImpliesExists(vn, f.(Conjunction).getAnOperand())
  or
  exprImpliesExists(vn, f.(ComparisonFormula).getAnOperand())
  or
  exists(IfFormula ifFormula |
    ifFormula = f and
    formulaImpliesExists(vn, ifFormula.getThenPart()) and
    formulaImpliesExists(vn, ifFormula.getElsePart())
  )
  or
  exprImpliesExists(vn, f.(InstanceOf).getExpr())
  or
  exprImpliesExists(vn, f.(PredicateCall).getAnArgument())
  or
  exprImpliesExists(vn, [f.(MemberCall).getAnArgument(), f.(MemberCall).getBase()])
  or
  exists(InFormula inFormula | inFormula = f |
    exprImpliesExists(vn, [inFormula.getExpr(), inFormula.getRange()])
  )
}

from TopLevelConjunction toplevel, Exists existsFormula, ValueNumber vn, Formula conjunct
where
  existsFormula = toplevel.getAnAtom() and
  vn.getAnExpr() = existsFormula.getExpr() and
  conjunct = toplevel.getAnAtom() and
  formulaImpliesExists(vn, conjunct)
select existsFormula, "This conjunct is superfluous as the existence is implied by $@.", conjunct,
  "this conjunct"
