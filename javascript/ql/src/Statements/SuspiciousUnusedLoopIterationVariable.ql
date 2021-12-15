/**
 * @name Unused loop iteration variable
 * @description A loop iteration variable is unused, which suggests an error.
 * @kind problem
 * @problem.severity error
 * @id js/unused-loop-variable
 * @tags maintainability
 *       correctness
 * @precision high
 */

import javascript

/**
 * An expression that adds a value to a variable.
 *
 * This includes `+=` expressions, pre- and post-increment expressions,
 * and expressions of the form `x = x + e`.
 */
class IncrementExpr extends Expr {
  IncrementExpr() {
    // x += e
    this instanceof AssignAddExpr
    or
    // ++x or x++
    this instanceof PreIncExpr
    or
    this instanceof PostIncExpr
    or
    // x = x + e
    exists(AssignExpr assgn, Variable v | assgn = this |
      assgn.getTarget() = v.getAnAccess() and
      assgn.getRhs().(AddExpr).getAnOperand().getUnderlyingReference() = v.getAnAccess()
    )
  }
}

/**
 * Holds if `efl` is a loop whose body increments a variable and does nothing else.
 */
predicate countingLoop(EnhancedForLoop efl) {
  exists(ExprStmt inc | inc.getExpr().stripParens() instanceof IncrementExpr |
    inc = efl.getBody() or
    inc = efl.getBody().(BlockStmt).getAStmt()
  )
}

/**
 * Holds if `iter` is a non-last variable of array-destructuring in a for-loop.
 * For example `foo` or `iter` in `for(const [foo, iter, bar] of array) {..}`.
 */
predicate isNonLastDestructedArrayElement(PurelyLocalVariable iter) {
  exists(ArrayPattern pattern | pattern = any(EnhancedForLoop loop).getLValue() |
    iter = pattern.getAVariable() and
    iter =
      pattern
          .getElement([0 .. pattern.getSize() - 2])
          .(BindingPattern)
          .getABindingVarRef()
          .getVariable()
  )
}

from EnhancedForLoop efl, PurelyLocalVariable iter
where
  iter = efl.getAnIterationVariable() and
  not exists(SsaExplicitDefinition ssa | ssa.defines(efl.getIteratorExpr(), iter)) and
  exists(ReachableBasicBlock body | body.getANode() = efl.getBody() | body.getASuccessor+() = body) and
  not countingLoop(efl) and
  not isNonLastDestructedArrayElement(iter) and
  not iter.getName().toLowerCase().regexpMatch("(_|dummy|unused).*")
select efl.getIterator(), "For loop variable " + iter.getName() + " is not used in the loop body."
