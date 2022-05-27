private import codeql.swift.generated.stmt.LabeledStmt

class LabeledStmt extends LabeledStmtBase {
  override string toString() { result = this.getLabel() + ": ..." }
}
