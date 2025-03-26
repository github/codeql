private import AstImport

class CatchClause extends Ast, TCatchClause {
  StmtBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, catchClauseBody(), result)
      or
      not synthChild(r, catchClauseBody(), _) and
      result = getResultAst(r.(Raw::CatchClause).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = catchClauseBody() and result = this.getBody()
    or
    exists(int index |
      i = catchClauseType(index) and
      result = this.getCatchType(index)
    )
  }

  override string toString() { result = "catch {...}" }

  TryStmt getTryStmt() { result.getACatchClause() = this }

  predicate isLast() {
    exists(TryStmt ts, int last |
      ts = this.getTryStmt() and
      last = max(int i | exists(ts.getCatchClause(i))) and
      this = ts.getCatchClause(last)
    )
  }

  TypeConstraint getCatchType(int i) {
    exists(ChildIndex index, Raw::Ast r | index = catchClauseType(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::CatchClause).getCatchType(i))
    )
  }

  int getNumberOfCatchTypes() { result = count(this.getACatchType()) }

  TypeConstraint getACatchType() { result = this.getCatchType(_) }

  predicate isCatchAll() { not exists(this.getACatchType()) }
}

class GeneralCatchClause extends CatchClause {
  GeneralCatchClause() { this.isCatchAll() }

  override string toString() { result = "catch {...}" }
}

class SpecificCatchClause extends CatchClause {
  SpecificCatchClause() { not this.isCatchAll() }

  override string toString() { result = "catch[...] {...}" }
}
