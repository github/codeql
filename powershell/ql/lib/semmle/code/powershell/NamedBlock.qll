import powershell

class NamedBlock extends @named_block, Ast {
  override string toString() { result = "{...}" }

  override SourceLocation getLocation() { named_block_location(this, result) }

  int getNumStatements() { named_block(this, result, _) }

  int getNumTraps() { named_block(this, _, result) }

  Stmt getStatement(int i) { named_block_statement(this, i, result) }

  Stmt getAStatement() { result = this.getStatement(_) }

  TrapStmt getTrap(int i) { named_block_trap(this, i, result) }

  TrapStmt getATrap() { result = this.getTrap(_) }
}
