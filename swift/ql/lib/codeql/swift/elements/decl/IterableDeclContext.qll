private import codeql.swift.generated.decl.IterableDeclContext
private import codeql.swift.elements.decl.NominalTypeDecl
private import codeql.swift.elements.decl.ExtensionDecl

class IterableDeclContext extends Generated::IterableDeclContext {
  /**
   * Gets the `NominalTypeDecl` corresponding to this `IterableDeclContext`
   * resolving an extension to the extended type declaration.
   */
  NominalTypeDecl resolveExtensions() {
    result = this.(NominalTypeDecl)
    or
    result = this.(ExtensionDecl).getExtendedTypeDecl()
  }
}
