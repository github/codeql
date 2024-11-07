private import codeql.swift.generated.decl.ExtensionDecl

module Impl {
  class ExtensionDecl extends Generated::ExtensionDecl {
    override string toString() {
      result =
        "extension of " + unique(NominalTypeDecl td | td = this.getExtendedTypeDecl()).toString()
      or
      count(this.getExtendedTypeDecl()) != 1 and
      result = "extension"
    }
  }
}
