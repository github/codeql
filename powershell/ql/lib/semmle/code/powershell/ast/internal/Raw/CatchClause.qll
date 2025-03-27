private import Raw

class CatchClause extends @catch_clause, Ast {
  override SourceLocation getLocation() { catch_clause_location(this, result) }

  StmtBlock getBody() { catch_clause(this, result, _) }

  final override Ast getChild(ChildIndex i) {
    i = CatchClauseBody() and
    result = this.getBody()
    or
    exists(int index |
      i = CatchClauseType(index) and
      result = this.getCatchType(index)
    )
  }

  TypeConstraint getCatchType(int i) { catch_clause_catch_type(this, i, result) }

  int getNumberOfCatchTypes() { result = count(this.getACatchType()) }

  TypeConstraint getACatchType() { result = this.getCatchType(_) }

  predicate isCatchAll() { not exists(this.getACatchType()) }
}
