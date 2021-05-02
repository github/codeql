/**
 * @name Errors When Using Variable Declaration Inside Loop
 * @description Using variables with the same name is dangerous.
 *              However, such a situation inside the while loop can lead to a violation of the accessibility of the program.
 *              Requires the attention of developers.
 * @kind problem
 * @id cpp/errors-when-using-variable-declaration-inside-loop
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-1126
 */

import cpp

/**
 * Errors when using a variable declaration inside a loop.
 */
class DangerousWhileLoop extends WhileStmt {
  Expr exp;
  Declaration dl;

  DangerousWhileLoop() {
    this = dl.getParentScope().(BlockStmt).getParent*() and
    exp = this.getCondition().getAChild*() and
    not exp instanceof PointerFieldAccess and
    not exp instanceof ValueFieldAccess and
    exp.(VariableAccess).getTarget().getName() = dl.getName() and
    not exp.getParent*() instanceof CrementOperation and
    not exp.getParent*() instanceof Assignment and
    not exp.getParent*() instanceof FunctionCall
  }

  Declaration getDeclaration() { result = dl }

  /** Holds when there are changes to the variables involved in the condition. */
  predicate isUseThisVariable() {
    exists(Variable v |
      this.getCondition().getAChild*().(VariableAccess).getTarget() = v and
      (
        exists(Assignment aexp |
          aexp = this.getStmt().getAChild*() and
          (
            aexp.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() = v
            or
            aexp.getLValue().(VariableAccess).getTarget() = v
          )
        )
        or
        exists(CrementOperation crm |
          crm = this.getStmt().getAChild*() and
          crm.getOperand().(VariableAccess).getTarget() = v
        )
      )
    )
  }
}

from DangerousWhileLoop lp
where not lp.isUseThisVariable()
select lp.getDeclaration(), "A variable with this name is used in the loop condition."
