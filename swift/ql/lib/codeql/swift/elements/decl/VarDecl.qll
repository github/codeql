private import codeql.swift.generated.decl.VarDecl
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.decl.DeclWithMembers

class VarDecl extends Generated::VarDecl {
  override string toString() { result = this.getName() }

  DeclRefExpr getAnAccess() { result.getDecl() = this }
}

class FieldDecl extends VarDecl {
  FieldDecl() { this = any(DeclWithMembers ctx).getAMember() }
}
