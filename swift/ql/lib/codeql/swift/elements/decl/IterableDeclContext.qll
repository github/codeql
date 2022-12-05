private import codeql.swift.generated.decl.IterableDeclContext
private import codeql.swift.elements.decl.NominalTypeDecl
private import codeql.swift.elements.decl.ExtensionDecl

/**
 * A nominal type (class, struct, enum or protocol) or extension.
 */
class IterableDeclContext extends Generated::IterableDeclContext {
  /**
   * Gets the `NominalTypeDecl` corresponding to this `IterableDeclContext`
   * resolving an extension to the extended type declaration.
   */
  NominalTypeDecl getNominalTypeDecl() {
    result = this.(NominalTypeDecl)
    or
    result = this.(ExtensionDecl).getExtendedTypeDecl()
  }
}
