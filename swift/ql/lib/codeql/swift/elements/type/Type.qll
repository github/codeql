private import codeql.swift.generated.type.Type
private import codeql.swift.elements.type.NominalType
private import codeql.swift.elements.type.TypeAliasType

class Type extends Generated::Type {
  override string toString() { result = this.getName() }

  /**
   * Gets this type after any type aliases have been resolved. For example in
   * the following code, the underlying type of `MyInt` is `Int`:
   * ```
   * typealias MyInt = Int
   * ```
   */
  Type getUnderlyingType() { result = this }

  /**
   * Gets any base type of this type, or the result of resolving a typedef. For
   * example in the following code, `C` has base type `B` which has underlying
   * type `A`. Thus, `getABaseOrAliasedType*` can be used to discover the
   * relationship between `C` and `A`.
   * ```
   * class A {}
   *
   * typealias B = A
   *
   * class C : B {}
   * ```
   */
  Type getABaseOrAliasedType() {
    result = this.(NominalType).getABaseType() or
    result = this.(TypeAliasType).getAliasedType()
  }
}
