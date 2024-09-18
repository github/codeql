private import codeql.swift.generated.type.LValueType

module Impl {
  class LValueType extends Generated::LValueType {
    override Type getResolveStep() { result = this.getImmediateObjectType() }
  }
}
