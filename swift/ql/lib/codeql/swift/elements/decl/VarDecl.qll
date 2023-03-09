private import codeql.swift.generated.decl.VarDecl
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.decl.Decl

class VarDecl extends Generated::VarDecl {
  override string toString() { result = this.getName() }

  DeclRefExpr getAnAccess() { result.getDecl() = this }
}

class FieldDecl extends VarDecl {
  FieldDecl() { this = any(Decl ctx).getAMember() }
}
