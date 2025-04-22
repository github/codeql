private import Raw

class CmdExpr extends @command_expression, CmdBase {
  override SourceLocation getLocation() { command_expression_location(this, result) }

  Expr getExpr() { command_expression(this, result, _) }

  final override Ast getChild(ChildIndex i) {
    i = CmdExprExpr() and
    result = this.getExpr()
  }

  int getNumRedirections() { command_expression(this, _, result) }

  Redirection getRedirection(int i) { command_expression_redirection(this, i, result) }

  Redirection getARedirection() { result = this.getRedirection(_) }
}
