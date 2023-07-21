private import codeql.swift.generated.decl.ExtensionDecl

class ExtensionDecl extends Generated::ExtensionDecl {
  override string toString() {
    result = "extension of " + this.getExtendedTypeDecl().toString()
    or
    not exists(this.getExtendedTypeDecl()) and
    result = "extension"
  }
}
