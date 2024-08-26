import powershell

query predicate doUntil(DoUntilStmt s, PipelineBase e, StmtBlock body) {
  e = s.getCondition() and
  body = s.getBody()
}

query predicate doWhile(DoWhileStmt s, PipelineBase e, StmtBlock body) {
  e = s.getCondition() and
  body = s.getBody()
}

query predicate while(WhileStmt s, PipelineBase e, StmtBlock body) {
  e = s.getCondition() and
  body = s.getBody()
}
