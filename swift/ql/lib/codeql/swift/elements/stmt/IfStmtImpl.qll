private import codeql.swift.generated.stmt.IfStmt
private import codeql.swift.elements.stmt.ConditionElement

module Impl {
  class IfStmt extends Generated::IfStmt {
    ConditionElement getACondition() { result = this.getCondition(_) }

    ConditionElement getCondition(int i) { result = this.getCondition().getElement(i) }

    Stmt getBranch(boolean b) {
      b = true and
      result = this.getThen()
      or
      b = false and
      result = this.getElse()
    }

    override string toString() {
      if this.hasElse()
      then result = "if ... then { ... } else { ... }"
      else result = "if ... then { ... }"
    }
  }
}
