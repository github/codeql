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
}
