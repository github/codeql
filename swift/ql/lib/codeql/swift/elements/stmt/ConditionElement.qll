private import codeql.swift.generated.stmt.ConditionElement
private import codeql.swift.elements.AstNode

class ConditionElement extends ConditionElementBase {
  AstNode getUnderlyingCondition() {
    result = this.getBoolean()
    or
    result = this.getInitializer()
    or
    result = this.getPattern()
  }

  override string toString() { result = this.getUnderlyingCondition().toString() }
}
