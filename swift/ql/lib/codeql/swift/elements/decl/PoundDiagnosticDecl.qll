private import codeql.swift.generated.decl.PoundDiagnosticDecl

class PoundDiagnosticDecl extends Generated::PoundDiagnosticDecl {
  override string toString() {
    this.isError() and result = "#error(...)"
    or
    this.isWarning() and result = "#warning(...)"
  }

  predicate isError() { this.getKind() = 1 }

  predicate isWarning() { this.getKind() = 2 }
}
