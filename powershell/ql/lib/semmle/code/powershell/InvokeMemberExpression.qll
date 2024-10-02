import powershell

class InvokeMemberExpr extends @invoke_member_expression, MemberExprBase {
  override SourceLocation getLocation() { invoke_member_expression_location(this, result) }

  Expr getQualifier() { invoke_member_expression(this, result, _) }

  string getName() { result = this.getMember().(StringConstExpr).getValue().getValue() }

  CmdElement getMember() { invoke_member_expression(this, _, result) }

  Expr getArgument(int i) { invoke_member_expression_argument(this, i, result) }

  Expr getAnArgument() { invoke_member_expression_argument(this, _, result) }

  override string toString() { result = "call to " + this.getName() }

  override predicate isStatic() { this.getQualifier() instanceof TypeNameExpr }
}

class ConstructorCall extends InvokeMemberExpr {
  ConstructorCall() { this.isStatic() and this.getName() = "new" }

  Type getConstructedType() { result = this.getQualifier().(TypeNameExpr).getType() }
}
