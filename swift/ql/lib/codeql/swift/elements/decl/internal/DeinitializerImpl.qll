private import codeql.swift.generated.decl.Deinitializer
private import codeql.swift.elements.decl.Method

module Impl {
  /**
   * A deinitializer of a class.
   */
  class Deinitializer extends Generated::Deinitializer {
    override string toString() { result = this.getSelfParam().getType() + "." + super.toString() }
  }
}
