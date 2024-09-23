private import codeql.swift.generated.stmt.SwitchStmt

module Impl {
  class SwitchStmt extends Generated::SwitchStmt {
    CaseStmt getFirstCase() { result = this.getCase(0) }

    CaseStmt getLastCase() {
      exists(int i |
        result = this.getCase(i) and
        not exists(this.getCase(i + 1))
      )
    }

    override string toString() { result = "switch " + this.getExpr().toString() + " { ... }" }
  }
}
