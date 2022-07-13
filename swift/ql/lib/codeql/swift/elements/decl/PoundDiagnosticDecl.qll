private import codeql.swift.generated.decl.PoundDiagnosticDecl

class PoundDiagnosticDecl extends PoundDiagnosticDeclBase {
  override string toString() {
    result = "#..." // TODO: Once we extract whether this is an error or a warning we can improve this.
  }
}
