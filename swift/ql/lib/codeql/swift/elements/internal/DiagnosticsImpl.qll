private import codeql.swift.generated.Diagnostics

module Impl {
  /**
   * A compiler-generated error, warning, note or remark.
   */
  class Diagnostics extends Generated::Diagnostics {
    override string toString() { result = this.getSeverity() + ": " + this.getText() }

    /**
     * Gets a string representing the severity of this compiler diagnostic.
     */
    string getSeverity() {
      this.getKind() = 1 and result = "error"
      or
      this.getKind() = 2 and result = "warning"
      or
      this.getKind() = 3 and result = "note"
      or
      this.getKind() = 4 and result = "remark"
    }
  }
}
