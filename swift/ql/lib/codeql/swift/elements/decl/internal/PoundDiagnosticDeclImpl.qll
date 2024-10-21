private import codeql.swift.generated.decl.PoundDiagnosticDecl

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A diagnostic directive, which is either `#error` or `#warning`.
   */
  class PoundDiagnosticDecl extends Generated::PoundDiagnosticDecl {
    override string toString() {
      this.isError() and result = "#error(...)"
      or
      this.isWarning() and result = "#warning(...)"
    }

    predicate isError() { this.getKind() = 1 }

    predicate isWarning() { this.getKind() = 2 }
  }
}
