private import codeql.swift.generated.stmt.ConditionElement
private import codeql.swift.elements.AstNode

class ConditionElement extends ConditionElementBase {
  override string toString() {
    result = this.getBoolean().toString()
    or
    result = this.getPattern().toString() + " = ... "
  }
}
