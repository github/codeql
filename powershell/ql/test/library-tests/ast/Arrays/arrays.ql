import powershell

query predicate arrayExpr(ArrayExpr arrayExpr, StmtBlock subExpr) { subExpr = arrayExpr.getStatementBlock() }

query predicate arrayLiteral(ArrayLiteral arrayLiteral, int i, Expr e) {
    e = arrayLiteral.getElement(i)
}
