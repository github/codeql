import Diagnostics

/**
 * A compiler error message.
 */
final class CompilerError extends Diagnostics {
  CompilerError() { this.getSeverity() = "error" }
}

/**
 * A compiler-generated warning.
 */
final class CompilerWarning extends Diagnostics {
  CompilerWarning() { this.getSeverity() = "warning" }
}

/**
 * A compiler-generated note (typically attached to an error or warning).
 */
final class CompilerNote extends Diagnostics {
  CompilerNote() { this.getSeverity() = "note" }
}

/**
 * A compiler-generated remark (milder than a warning, this does not indicate an issue).
 */
final class CompilerRemark extends Diagnostics {
  CompilerRemark() { this.getSeverity() = "remark" }
}
