private import codeql.swift.generated.type.Type

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
   * Gets any base type of this type. For a `typealias`, this is a base type
   * of the aliased type. For example in the following code, both `B` and
   * `B_alias` have base type `A`.
   * ```
   * class A {}
   *
   * class B : A {}
   *
   * typealias B_alias = B
   * ```
   */
  Type getABaseType() { none() }
}
