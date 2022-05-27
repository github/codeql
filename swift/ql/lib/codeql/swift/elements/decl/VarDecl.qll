private import codeql.swift.generated.decl.VarDecl
private import codeql.swift.elements.expr.DeclRefExpr

class VarDecl extends VarDeclBase {
  override string toString() { result = this.getName() }

  DeclRefExpr getAnAccess() { result.getDecl() = this }
}
