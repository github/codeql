private import codeql.swift.generated.decl.Deinitializer
private import codeql.swift.elements.decl.Method

module Impl {
  /**
   * A deinitializer of a class.
   */
  class Deinitializer extends Generated::Deinitializer {
    override string toStringImpl() {
      result = this.getSelfParam().getType().toStringImpl() + "." + super.toStringImpl()
    }
  }
}
