private import AstImport

class UsingStmt extends Stmt, TUsingStmt {
  override string toString() { result = "using ..." }

  string getName() { result = getRawAst(this).(Raw::UsingStmt).getName() }

  Scope getAnAffectedScope() { result.getEnclosingScope*() = this.getEnclosingScope() }
}
