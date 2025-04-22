import powershell

query predicate binaryExpr(BinaryExpr e, Expr e1, Expr e2) {
  e1 = e.getLeft() and
  e2 = e.getRight()
}

query predicate cmdExpr(ExprStmt exprStmt, Expr e) { e = exprStmt.getExpr() }

query predicate invokeMemoryExpression(InvokeMemberExpr invoke, Expr e, int i, Expr arg) {
  e = invoke.getQualifier() and
  arg = invoke.getArgument(i)
}

query predicate expandableString(ExpandableStringExpr expandable, int i, Expr e) {
  e = expandable.getExpr(i)
}

query predicate memberExpr(MemberExpr expr, Expr e) { e = expr.getQualifier() }
