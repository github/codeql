private import codeql.swift.generated.type.DynamicSelfType

module Impl {
  class DynamicSelfType extends Generated::DynamicSelfType {
    override Type getResolveStep() {
      // The type of qualifiers in a Swift constructor is assigned the type `Self` by the Swift compiler
      // This `getResolveStep` replaces that `Self` type with the type of the enclosing class.
      result = this.getImmediateStaticSelfType()
    }
  }
}
