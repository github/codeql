private import codeql.swift.elements.type.Type
private import codeql.swift.generated.type.TypeAliasType

class TypeAliasType extends Generated::TypeAliasType {
  /**
   * Gets the aliased type of this type alias type.
   *
   * For example the aliased type of `MyInt` in the following code is `Int`:
   * ```
   * typealias MyInt = Int
   * ```
   */
  Type getAliasedType() { none() } // TODO: not yet implemented.

  override Type getUnderlyingType() { result = this } // TODO: not yet implemented.
}
