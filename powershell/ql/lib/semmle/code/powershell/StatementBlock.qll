import powershell

class StmtBlock extends @statement_block, Ast {
  override SourceLocation getLocation() { statement_block_location(this, result) }

  int getNumStatements() { statement_block(this, result, _) }

  int getNumTraps() { statement_block(this, _, result) }

  Stmt getStatement(int index) { statement_block_statement(this, index, result) }

  Stmt getAStatement() { result = this.getStatement(_) }

  TrapStmt getTrapStatement(int index) { statement_block_trap(this, index, result) }

  TrapStmt getATrapStatement() { result = this.getTrapStatement(_) }

  override string toString() { result = "StatementBlock at: " + this.getLocation().toString() }
}
