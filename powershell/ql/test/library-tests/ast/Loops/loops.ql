import powershell

query predicate doUntil(DoUntilStmt s, Expr e, StmtBlock body) {
  e = s.getCondition() and
  body = s.getBody()
}

query predicate doWhile(DoWhileStmt s, Expr e, StmtBlock body) {
  e = s.getCondition() and
  body = s.getBody()
}

query predicate while(WhileStmt s, Expr e, StmtBlock body) {
  e = s.getCondition() and
  body = s.getBody()
}
