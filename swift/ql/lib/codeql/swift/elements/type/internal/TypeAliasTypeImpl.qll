private import codeql.swift.elements.type.Type
private import codeql.swift.generated.type.TypeAliasType

module Impl {
  /**
   * A type alias to another type. For example:
   * ```
   * typealias MyInt = Int
   * ```
   */
  class TypeAliasType extends Generated::TypeAliasType {
    /**
     * Gets the aliased type of this type alias type.
     *
     * For example the aliased type of `MyInt` in the following code is `Int`:
     * ```
     * typealias MyInt = Int
     * ```
     */
    Type getAliasedType() { result = this.getDecl().getAliasedType() }

    override Type getUnderlyingType() { result = this.getAliasedType().getUnderlyingType() }
  }
}
