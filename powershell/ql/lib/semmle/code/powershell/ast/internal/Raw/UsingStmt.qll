private import Raw

class UsingStmt extends @using_statement, Stmt {
  override SourceLocation getLocation() { using_statement_location(this, result) }

  string getName() {
    exists(StringConstExpr const |
      using_statement_name(this, const) and // TODO: Change dbscheme
      result = const.getValue().getValue()
    )
  }

  string getAlias() {
    exists(StringConstExpr const |
      using_statement_alias(this, const) and // TODO: Change dbscheme
      result = const.getValue().getValue()
    )
  }
}
