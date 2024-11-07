private import codeql.swift.generated.stmt.DoCatchStmt

module Impl {
  class DoCatchStmt extends Generated::DoCatchStmt {
    CaseStmt getFirstCatch() { result = this.getCatch(0) }

    CaseStmt getLastCatch() {
      exists(int i |
        result = this.getCatch(i) and
        not exists(this.getCatch(i + 1))
      )
    }

    override string toString() { result = "do { ... } catch { ... }" }
  }
}
