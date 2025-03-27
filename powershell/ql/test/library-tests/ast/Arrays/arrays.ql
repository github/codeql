import powershell

query predicate arrayExpr(ArrayExpr arrayExpr, StmtBlock subExpr) { subExpr = arrayExpr.getStmtBlock() }

query predicate arrayLiteral(ArrayLiteral arrayLiteral, int i, Expr e) {
    e = arrayLiteral.getExpr(i)
}
