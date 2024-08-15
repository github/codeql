import powershell

class InvokeMemberExpression extends @invoke_member_expression, MemberExpressionBase {
  override SourceLocation getLocation() { invoke_member_expression_location(this, result) }

  Expression getExpression() { invoke_member_expression(this, result, _) }

  CommandElement getMember() { invoke_member_expression(this, _, result) }

  Expression getArgument(int i) { invoke_member_expression_argument(this, i, result) }

  Expression getAnArgument() { invoke_member_expression_argument(this, _, result) }

  override string toString() { result = "ArrayExpression at: " + this.getLocation().toString() }
}
