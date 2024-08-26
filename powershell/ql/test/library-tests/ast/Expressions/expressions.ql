import powershell

query predicate binaryExpr(BinaryExpr e, Expr e1, Expr e2) {
    e1 = e.getLeft() and
    e2 = e.getRight()
}

query predicate cmdExpr(CmdExpr cmd, Expr e) {
    e = cmd.getExpression()
}

query predicate invokeMemoryExpression(InvokeMemberExpression invoke, Expr e, int i, Expr arg) {
    e = invoke.getExpression() and
    arg = invoke.getArgument(i)
}

query predicate expandableString(ExpandableStringExpression expandable, int i, Expr e) {
    e = expandable.getExpr(i)
}
