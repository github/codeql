private import codeql.swift.elements.type.Type
private import codeql.swift.generated.type.TypeAliasType

class TypeAliasType extends Generated::TypeAliasType {
  /**
   * Gets the the aliased type of this type alias declaration.
   */
  Type getAliasedType() { result = this.getDecl().getAliasedType() }

  override Type getUnderlyingType() { result = this.getAliasedType().getUnderlyingType() }
}
