import powershell

class CatchClause extends @catch_clause, Ast {
  override SourceLocation getLocation() { catch_clause_location(this, result) }

  override string toString() { result = "catch {...}" }

  StmtBlock getBody() { catch_clause(this, result, _) }

  TypeConstraint getCatchType(int i) { catch_clause_catch_type(this, i, result) }

  int getNumberOfCatchTypes() { result = count(this.getACatchType()) }

  TypeConstraint getACatchType() { result = this.getCatchType(_) }

  predicate isCatchAll() { not exists(this.getACatchType()) }

  TryStmt getTryStmt() { result.getACatchClause() = this }

  predicate isLast() {
    exists(TryStmt ts, int last |
      ts = this.getTryStmt() and
      last = max(int i | exists(ts.getCatchClause(i))) and
      this = ts.getCatchClause(last)
    )
  }
}

class GeneralCatchClause extends CatchClause {
  GeneralCatchClause() { this.isCatchAll() }

  override string toString() { result = "catch {...}" }
}

class SpecificCatchClause extends CatchClause {
  SpecificCatchClause() { not this.isCatchAll() }

  override string toString() { result = "catch[...] {...}" }
}
