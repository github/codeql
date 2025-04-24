private import Raw

class InvokeMemberExpr extends @invoke_member_expression, MemberExprBase {
  override SourceLocation getLocation() { invoke_member_expression_location(this, result) }

  Expr getQualifier() { invoke_member_expression(this, result, _) }

  Expr getCallee() { invoke_member_expression(this, _, result) }

  string getLowerCaseName() { result = this.getCallee().(StringConstExpr).getValue().getValue().toLowerCase() }

  Expr getArgument(int i) { invoke_member_expression_argument(this, i, result) }

  Expr getAnArgument() { invoke_member_expression_argument(this, _, result) }

  final override Ast getChild(ChildIndex i) {
    i = InvokeMemberExprQual() and
    result = this.getQualifier()
    or
    i = InvokeMemberExprCallee() and
    result = this.getCallee()
    or
    exists(int index |
      i = InvokeMemberExprArg(index) and
      result = this.getArgument(index)
    )
  }

  override predicate isStatic() { this.getQualifier() instanceof TypeNameExpr }
}
