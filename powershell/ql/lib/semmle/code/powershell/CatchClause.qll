import powershell

class CatchClause extends @catch_clause, Ast {
  override SourceLocation getLocation() { catch_clause_location(this, result) }

  override string toString() { result = "catch {...}" }

  StmtBlock getBody() { catch_clause(this, result, _) } // TODO: Change @ast to @stmt_block in dbscheme

  TypeConstraint getCatchType(int i) { catch_clause_catch_type(this, i, result) } // TODO: Change @ast to @type_constraint in dbscheme

  TypeConstraint getACatchType() { result = this.getCatchType(_) }

  predicate isCatchAll() { catch_clause(this, _, true) } // TODO: Should be equivalent to not exists(this.getACatchType())

  TryStmt getTryStmt() { result.getACatchClause() = this }
}
