private import codeql.swift.generated.decl.VarDecl
private import codeql.swift.elements.expr.DeclRefExpr

class VarDecl extends VarDeclBase {
  DeclRefExpr getAnAccess() { result.getDecl() = this }
}
