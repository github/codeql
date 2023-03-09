private import codeql.swift.generated.type.LValueType

class LValueType extends Generated::LValueType {
  override Type getResolveStep() { result = this.getImmediateObjectType() }
}
