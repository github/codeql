private import AstImport

class StmtBlock extends Stmt, TStmtBlock {
  pragma[nomagic]
  Stmt getStmt(int i) {
    exists(ChildIndex index, Raw::Ast r | index = stmtBlockStmt(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::StmtBlock).getStmt(i))
    )
  }

  Stmt getAStmt() { result = this.getStmt(_) }

  TrapStmt getTrapStmt(int i) {
    exists(ChildIndex index, Raw::Ast r | index = stmtBlockTrapStmt(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::StmtBlock).getTrapStmt(i))
    )
  }

  TrapStmt getATrapStmt() { result = this.getTrapStmt(_) }

  int getNumberOfStmts() { result = count(this.getAStmt()) }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = stmtBlockStmt(index) and
      result = this.getStmt(index)
      or
      i = stmtBlockTrapStmt(index) and
      result = this.getTrapStmt(index)
    )
  }

  override string toString() { result = "{...}" }
}
