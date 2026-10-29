private import codeql.swift.generated.stmt.ConditionElement
private import codeql.swift.elements.AstNode

module Impl {
  class ConditionElement extends Generated::ConditionElement {
    override string toStringImpl() {
      result = this.getBoolean().toStringImpl()
      or
      result = this.getPattern().toStringImpl() + " = ... "
      or
      result = this.getAvailability().toStringImpl()
    }
  }
}
