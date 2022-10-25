private import codeql.swift.generated.stmt.LabeledStmt

class LabeledStmt extends Generated::LabeledStmt {
  override string toString() { result = this.getLabel() + ": ..." }
}
