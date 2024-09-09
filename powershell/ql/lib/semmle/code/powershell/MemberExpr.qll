import powershell

class MemberExpr extends @member_expression, MemberExprBase {
  final override Location getLocation() { member_expression_location(this, result) }

  Expr getExpr() { member_expression(this, result, _, _, _) }

  CmdElement getMember() { member_expression(this, _, result, _, _) }

  predicate isNullConditional() { member_expression(this, _, _, true, _) }

  predicate isStatic() { member_expression(this, _, _, _, true) }

  final override string toString() { result = this.getMember().toString() }
}
