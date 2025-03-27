private import Raw

class DynamicStmt extends @dynamic_keyword_statement, Stmt {
  override SourceLocation getLocation() { dynamic_keyword_statement_location(this, result) }

  CmdElement getName() { dynamic_keyword_statement_command_elements(this, 1, result) }

  ScriptBlockExpr getScriptBlock() { dynamic_keyword_statement_command_elements(this, 2, result) }

  HashTableExpr getHashTableExpr() { dynamic_keyword_statement_command_elements(this, 2, result) }

  predicate hasScriptBlock() { exists(this.getScriptBlock()) }

  predicate hasHashTableExpr() { exists(this.getHashTableExpr()) }

  final override Ast getChild(ChildIndex i) {
    i = DynamicStmtName() and
    result = this.getName()
    or
    i = DynamicStmtBody() and
    (
      result = this.getScriptBlock()
      or
      result = this.getHashTableExpr()
    )
  }
}
