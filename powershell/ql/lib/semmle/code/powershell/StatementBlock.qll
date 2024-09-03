import powershell

class StmtBlock extends @statement_block, Ast {
  override SourceLocation getLocation() { statement_block_location(this, result) }

  int getNumberOfStmts() { statement_block(this, result, _) }

  int getNumTraps() { statement_block(this, _, result) }

  Stmt getStmt(int index) { statement_block_statement(this, index, result) }

  Stmt getAStmt() { result = this.getStmt(_) }

  TrapStmt getTrapStmt(int index) { statement_block_trap(this, index, result) }

  TrapStmt getATrapStmt() { result = this.getTrapStmt(_) }

  override string toString() { result = "{...}" }
}
