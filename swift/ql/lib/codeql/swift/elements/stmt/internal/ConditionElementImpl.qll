private import codeql.swift.generated.stmt.ConditionElement
private import codeql.swift.elements.AstNode

module Impl {
  class ConditionElement extends Generated::ConditionElement {
    override string toString() {
      result = this.getBoolean().toString()
      or
      result = this.getPattern().toString() + " = ... "
      or
      result = this.getAvailability().toString()
    }
  }
}
