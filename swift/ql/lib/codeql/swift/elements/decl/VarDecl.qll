private import codeql.swift.generated.decl.VarDecl
private import codeql.swift.elements.decl.Decl

/**
 * A variable declaration.
 */
class VarDecl extends Generated::VarDecl {
  override string toString() { result = this.getName() }
}

/**
 * A field declaration.
 */
class FieldDecl extends VarDecl {
  FieldDecl() { this = any(Decl ctx).getAMember() }
}
