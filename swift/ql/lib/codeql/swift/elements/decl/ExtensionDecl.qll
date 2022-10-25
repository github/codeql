private import codeql.swift.generated.decl.ExtensionDecl

class ExtensionDecl extends Generated::ExtensionDecl {
  override string toString() {
    result = "extension" // TODO: Once we extract the name of this one we can provide a better `toString`.
  }
}
