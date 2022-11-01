private import codeql.swift.generated.decl.Decl
private import codeql.swift.elements.decl.DeclWithMembers
private import codeql.swift.elements.decl.NominalTypeDecl
private import codeql.swift.elements.decl.ExtensionDecl

class Decl extends Generated::Decl {
  /**
   * Gets the class, struct, enum, protocol, or extension that declared
   * this `Decl` as a member.
   */
  cached
  DeclWithMembers getDeclaringDecl() { result.getAMember() = this }

  /**
   * Gets the class, struct, enum, or protocol that declared
   * (or was extended with) this `Decl` as a member.
   */
  NominalTypeDecl getDeclaringTypeDecl() {
    result.getAMember() = this
    or
    result = any(ExtensionDecl e | e.getAMember() = this).getExtendedTypeDecl()
  }
}
