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
import semmle.javascript.dataflow.Refinements
import semmle.javascript.DefensiveProgramming

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
 * Holds if `e` directly uses a parameter's negated or initial value as passed in from the caller.
 */
predicate isInitialParameterUse(Expr e) {
  // unlike `SimpleParameter.getAnInitialUse` this will not include uses we have refinement information for
  exists (SimpleParameter p, SsaExplicitDefinition ssa |
    ssa.getDef() = p and
    ssa.getVariable().getAUse() = e and
    not p.isRestParameter()
  )
  or
  isInitialParameterUse(e.(LogNotExpr).getOperand())
}

/**
 * Holds if `e` directly uses the returned value from a function call that returns a constant boolean value.
 */
predicate isConstantBooleanReturnValue(Expr e) {
  // unlike `SourceNode.flowsTo` this will not include uses we have refinement information for
  exists (DataFlow::CallNode call |
    exists (call.analyze().getTheBooleanValue()) |
    e = call.asExpr() or
    // also support return values that are assigned to variables
    exists (SsaExplicitDefinition ssa |
      ssa.getDef().getSource() = call.asExpr() and
      ssa.getVariable().getAUse() = e
    )
  )
  or
  isConstantBooleanReturnValue(e.(LogNotExpr).getOperand())
}

private Expr maybeStripLogNot(Expr e) {
  result = maybeStripLogNot(e.(LogNotExpr).getOperand()) or
  result = e
}

/**
 * Holds if `e` is a defensive expression with a fixed outcome.
 */
predicate isConstantDefensive(Expr e) {
  exists(DefensiveExpressionTest defensive |
    maybeStripLogNot(defensive.asExpr()) = e and
    exists(defensive.getTheTestResult())
  )
}

/**
 * Holds if `e` is an expression that should not be flagged as a useless condition.
 *
 * We currently whitelist these kinds of expressions:
 *
 *   - constants (including references to literal constants);
 *   - negations of constants;
 *   - defensive checks;
 *   - expressions that rely on inter-procedural parameter information;
 *   - constant boolean returned values.
 */
predicate whitelist(Expr e) {
  isConstant(e) or
  isConstant(e.(LogNotExpr).getOperand()) or
  isConstantDefensive(e) or // flagged by js/useless-defensive-code
  isInitialParameterUse(e) or
  isConstantBooleanReturnValue(e)
}

/**
 * Holds if `e` is part of a conditional node `cond` that evaluates
 * `e` and checks its value for truthiness.
 */
predicate isConditional(ASTNode cond, Expr e) {
  e = cond.(IfStmt).getCondition() or
  e = cond.(LoopStmt).getTest() or
  e = cond.(ConditionalExpr).getCondition() or
  e = cond.(LogicalBinaryExpr).getLeftOperand() or
  // Include `z` in `if (x && z)`.
  isConditional(_, cond) and e = cond.(Expr).getUnderlyingValue().(LogicalBinaryExpr).getRightOperand()
}

from ASTNode cond, DataFlow::AnalyzedNode op, boolean cv, ASTNode sel, string msg
where isConditional(cond, op.asExpr()) and
      cv = op.getTheBooleanValue()and
      not whitelist(op.asExpr()) and

      // if `cond` is of the form `<non-trivial truthy expr> && <something>`,
      // we suggest replacing it with `<non-trivial truthy expr>, <something>`
      if cond.(LogAndExpr).getLeftOperand() = op.asExpr() and cv = true and not op.asExpr().isPure() then
        (sel = cond and msg = "This logical 'and' expression can be replaced with a comma expression.")

      // otherwise we just report that `op` always evaluates to `cv`
      else (
        sel = op.asExpr().stripParens() and
        msg = "This " + describeExpression(sel) + " always evaluates to " + cv + "."
      )

select sel, msg
