import semmle.code.cpp.exprs.Expr

/**
 * An expression that is used to qualify some other expression.
 */
class Qualifier extends Expr {
  Qualifier() {
    exists(VariableAccess a | a.getQualifier() = this) or
    exists(Call c | c.getQualifier() = this) or
    exists(VacuousDestructorCall v | v.getQualifier() = this)
  }
}

/**
 * An expression that occurs in a void context, i.e. either as the toplevel expression of
 * an expression statement or on the left hand side of the comma operator.
 *
 * Expressions that are explicitly cast to void are not considered to be in void context.
 */
class ExprInVoidContext extends Expr {
  ExprInVoidContext() { exprInVoidContext(this) }
}

private predicate exprInVoidContext(Expr e) {
  (
    exists(ExprStmt s |
      s = e.getParent() and
      not exists(StmtExpr se | s = se.getStmt().(BlockStmt).getLastStmt())
    )
    or
    exists(ConditionalExpr c | c.getThen() = e and c instanceof ExprInVoidContext)
    or
    exists(ConditionalExpr c | c.getElse() = e and c instanceof ExprInVoidContext)
    or
    exists(CommaExpr c | c.getLeftOperand() = e)
    or
    exists(CommaExpr c | c.getRightOperand() = e and c instanceof ExprInVoidContext)
    or
    exists(ForStmt for | for.getUpdate() = e)
  ) and
  not e.getActualType() instanceof VoidType
}
