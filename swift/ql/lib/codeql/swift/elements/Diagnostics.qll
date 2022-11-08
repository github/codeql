private import codeql.swift.generated.Diagnostics

class Diagnostics extends Generated::Diagnostics {
  override string toString() { result = getSeverity() + ": " + getText() }

  string getSeverity() {
    getKind() = 1 and result = "error"
    or
    getKind() = 2 and result = "warning"
    or
    getKind() = 3 and result = "note"
    or
    getKind() = 4 and result = "remark"
  }
}

class CompilerError extends Diagnostics {
  CompilerError() { this.getSeverity() = "error" }
}

class CompilerWarning extends Diagnostics {
  CompilerWarning() { this.getSeverity() = "warning" }
}

class CompilerNote extends Diagnostics {
  CompilerNote() { this.getSeverity() = "note" }
}

class CompilerRemark extends Diagnostics {
  CompilerRemark() { this.getSeverity() = "remark" }
}
