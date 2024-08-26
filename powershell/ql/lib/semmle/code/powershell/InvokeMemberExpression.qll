import powershell

class InvokeMemberExpression extends @invoke_member_expression, MemberExprBase {
  override SourceLocation getLocation() { invoke_member_expression_location(this, result) }

  Expr getExpression() { invoke_member_expression(this, result, _) }

  CmdElement getMember() { invoke_member_expression(this, _, result) }

  Expr getArgument(int i) { invoke_member_expression_argument(this, i, result) }

  Expr getAnArgument() { invoke_member_expression_argument(this, _, result) }

  override string toString() { result = "ArrayExpression at: " + this.getLocation().toString() }
}
