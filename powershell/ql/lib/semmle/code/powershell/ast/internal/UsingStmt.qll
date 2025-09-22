private import AstImport

/**
 * A using statement. For example:
 * ```
 * using namespace System.Collections.Generic
 * using module MyModule
 * using assembly System.Net.Http
 * ```
 */
class UsingStmt extends Stmt, TUsingStmt {
  override string toString() { result = "using ..." }

  string getName() { result = getRawAst(this).(Raw::UsingStmt).getName() }

  Scope getAnAffectedScope() { result.getEnclosingScope*() = this.getEnclosingScope() }
}
