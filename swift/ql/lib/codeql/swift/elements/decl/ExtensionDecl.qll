private import codeql.swift.generated.decl.ExtensionDecl

class ExtensionDecl extends Generated::ExtensionDecl {
  override string toString() {
    result = "extension of " + getExtendedTypeDecl().toString()
    or
    not exists(getExtendedTypeDecl()) and
    result = "extension"
  }
}
