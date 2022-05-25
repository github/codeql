private import codeql.swift.generated.stmt.SwitchStmt

class SwitchStmt extends SwitchStmtBase {
  CaseStmt getFirstCase() { result = this.getCase(0) }

  CaseStmt getLastCase() {
    exists(int i |
      result = this.getCase(i) and
      not exists(this.getCase(i + 1))
    )
  }
}
