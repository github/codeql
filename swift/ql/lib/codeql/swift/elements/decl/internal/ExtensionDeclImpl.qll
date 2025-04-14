private import codeql.swift.generated.decl.ExtensionDecl

module Impl {
  class ExtensionDecl extends Generated::ExtensionDecl {
    override string toStringImpl() {
      result =
        "extension of " +
          unique(NominalTypeDecl td | td = this.getExtendedTypeDecl()).toStringImpl()
      or
      count(this.getExtendedTypeDecl()) != 1 and
      result = "extension"
    }
  }
}
