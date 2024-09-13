private import codeql.swift.generated.stmt.StmtCondition

module Impl {
  class StmtCondition extends Generated::StmtCondition {
    ConditionElement getFirstElement() { result = this.getElement(0) }

    ConditionElement getLastElement() {
      exists(int i |
        result = this.getElement(i) and
        not exists(this.getElement(i + 1))
      )
    }
  }
}
