import ruby

query predicate caseValues(CaseExpr c, Expr value) { value = c.getValue() }

query predicate caseNoValues(CaseExpr c) { not exists(c.getValue()) }

query predicate caseElseBranches(CaseExpr c, StmtSequence elseBranch) {
  elseBranch = c.getElseBranch()
}

query predicate caseNoElseBranches(CaseExpr c) { not exists(c.getElseBranch()) }

query predicate caseWhenBranches(CaseExpr c, WhenClause when, int pIndex, Expr p, StmtSequence body) {
  when = c.getABranch() and
  p = when.getPattern(pIndex) and
  body = when.getBody()
}

query predicate caseAllBranches(CaseExpr c, int n, AstNode branch) { branch = c.getBranch(n) }
