private import codeql.swift.generated.Diagnostics

class Diagnostics extends Generated::Diagnostics {
  override string toString() { result = this.getSeverity() + ": " + this.getText() }

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
