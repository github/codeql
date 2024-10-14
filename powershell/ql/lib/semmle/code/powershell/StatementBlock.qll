import powershell
private import semmle.code.powershell.internal.AstEscape::Private

private module ReturnContainerInterpreter implements InterpretAstInputSig {
  class T = Ast;

  pragma[inline]
  T interpret(Ast a) { result = a }
}

class StmtBlock extends @statement_block, Ast {
  override SourceLocation getLocation() { statement_block_location(this, result) }

  int getNumberOfStmts() { statement_block(this, result, _) }

  int getNumTraps() { statement_block(this, _, result) }

  Stmt getStmt(int index) { statement_block_statement(this, index, result) }

  Stmt getAStmt() { result = this.getStmt(_) }

  TrapStmt getTrapStmt(int index) { statement_block_trap(this, index, result) }

  TrapStmt getATrapStmt() { result = this.getTrapStmt(_) }

  override string toString() { result = "{...}" }

  /** Gets an element that may escape this `StmtBlock`. */
  Ast getAnElement() {
    result = this.(AstEscape<ReturnContainerInterpreter>::Element).getAnEscapingElement()
  }
}
