private import codeql.swift.generated.Diagnostics

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

/**
 * A compiler error message.
 */
class CompilerError extends Diagnostics {
  CompilerError() { this.getSeverity() = "error" }
}

/**
 * A compiler-generated warning.
 */
class CompilerWarning extends Diagnostics {
  CompilerWarning() { this.getSeverity() = "warning" }
}

/**
 * A compiler-generated note (typically attached to an error or warning).
 */
class CompilerNote extends Diagnostics {
  CompilerNote() { this.getSeverity() = "note" }
}

/**
 * A compiler-generated remark (milder than a warning, this does not indicate an issue).
 */
class CompilerRemark extends Diagnostics {
  CompilerRemark() { this.getSeverity() = "remark" }
}
