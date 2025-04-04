private import codeql.swift.generated.decl.Decl
private import codeql.swift.elements.decl.NominalTypeDecl
private import codeql.swift.elements.decl.ExtensionDecl

module Impl {
  class Decl extends Generated::Decl {
    // needed to avoid spurious non-monotonicity error
    override string toStringImpl() { result = super.toStringImpl() }

    /**
     * Gets the `NominalTypeDecl` corresponding to this `Decl`, if any. This
     * resolves an `ExtensionDecl` to the `NominalTypeDecl` that it extends.
     */
    NominalTypeDecl asNominalTypeDecl() {
      result = this
      or
      result = this.(ExtensionDecl).getExtendedTypeDecl()
    }

    /**
     * Gets the declaration that declares this declaration as a member, if any.
     */
    Decl getDeclaringDecl() { this = result.getAMember() }
  }
}
