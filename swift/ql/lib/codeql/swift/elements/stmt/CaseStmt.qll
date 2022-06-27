private import codeql.swift.generated.stmt.CaseStmt

class CaseStmt extends CaseStmtBase {
  CaseLabelItem getFirstLabel() { result = this.getLabel(0) }

  CaseLabelItem getLastLabel() {
    exists(int i |
      result = this.getLabel(i) and
      not exists(this.getLabel(i + 1))
    )
  }

  override string toString() { result = "case ..." }
}
