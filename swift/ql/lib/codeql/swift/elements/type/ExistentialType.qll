private import codeql.swift.generated.type.ExistentialType
private import codeql.swift.elements.type.ProtocolType

class ExistentialType extends ExistentialTypeBase {
  override ProtocolType getConstraint() { result = super.getConstraint() }
}
