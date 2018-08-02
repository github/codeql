/**
 * @name Useless conditional
 * @description If a conditional expression always evaluates to true or always
 *              evaluates to false, this suggests incomplete code or a logic
 *              error.
 * @kind problem
 * @problem.severity warning
 * @id js/trivial-conditional
 * @tags correctness
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

/**
 * Holds if `va` is a defensive truthiness check that may be worth keeping, even if it
 * is strictly speaking useless.
 *
 * We currently recognize three patterns:
 *
 *   - the first `x` in `x || (x = e)`
 *   - the second `x` in `x = (x || e)`
 *   - the second `x` in `var x = x || e`
 */
predicate isDefensiveInit(VarAccess va) {
  exists (LogOrExpr o, VarRef va2 |
    va = o.getLeftOperand().stripParens() and va2.getVariable() = va.getVariable() |
    exists (AssignExpr assgn | va2 = assgn.getTarget() |
      assgn = o.getRightOperand().stripParens() or
      o = assgn.getRhs().stripParens()
    ) or
    exists (VariableDeclarator vd | va2 = vd.getBindingPattern() |
      o = vd.getInit().stripParens()
    )
  )
}

/**
 * Holds if variable `v` looks like a symbolic constant, that is, it is assigned
 * exactly once, either in a `const` declaration or with a constant initializer.
 *
 * We do not consider conditionals to be useless if they check a symbolic constant.
 */
predicate isSymbolicConstant(Variable v) {
  // defined exactly once
  count (VarDef vd | vd.getAVariable() = v) = 1 and
  // the definition is either a `const` declaration or it assigns a constant to it
  exists (VarDef vd | vd.getAVariable() = v and count(vd.getAVariable()) = 1 |
    vd.(VariableDeclarator).getDeclStmt() instanceof ConstDeclStmt or
    isConstant(vd.getSource())
  )
}

/**
 * Holds if `e` is a literal constant or a reference to a symbolic constant.
 */
predicate isConstant(Expr e) {
  e instanceof Literal or
  isSymbolicConstant(e.(VarAccess).getVariable())
}

/**
 * Holds if `e` is an expression that should not be flagged as a useless condition.
 *
 * We currently whitelist three kinds of expressions:
 *
 *   - constants (including references to literal constants);
 *   - negations of constants;
 *   - defensive checks.
 */
predicate whitelist(Expr e) {
  isConstant(e) or
  isConstant(e.(LogNotExpr).getOperand()) or
  isDefensiveInit(e)
}

/**
 * Holds if `e` is part of a conditional node `cond` that evaluates
 * `e` and checks its value for truthiness.
 */
predicate isConditional(ASTNode cond, Expr e) {
  e = cond.(IfStmt).getCondition() or
  e = cond.(ConditionalExpr).getCondition() or
  e = cond.(LogAndExpr).getLeftOperand() or
  e = cond.(LogOrExpr).getLeftOperand()
}

from ASTNode cond, DataFlow::AnalyzedNode op, boolean cv, ASTNode sel, string msg
where isConditional(cond, op.asExpr()) and
      cv = op.getTheBooleanValue()and
      not whitelist(op.asExpr()) and

      // if `cond` is of the form `<non-trivial truthy expr> && <something>`,
      // we suggest replacing it with `<non-trivial truthy expr>, <something>`
      if cond instanceof LogAndExpr and cv = true and not op.asExpr().isPure() then
        (sel = cond and msg = "This logical 'and' expression can be replaced with a comma expression.")

      // otherwise we just report that `op` always evaluates to `cv`
      else (
        sel = op.asExpr().stripParens() and
        if sel instanceof VarAccess then
          msg = "Variable '" + sel.(VarAccess).getVariable().getName() + "' always evaluates to " + cv + " here."
        else
          msg = "This expression always evaluates to " + cv + "."
      )

select sel, msg