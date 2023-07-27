private import codeql.swift.generated.type.Type

/**
 * A Swift type.
 *
 * This QL class is the root of the Swift type hierarchy.
 */
class Type extends Generated::Type {
  override string toString() { result = this.getName() }

  /**
   * Gets the name of this type.
   */
  override string getName() {
    /*exists(string name, int lastDotPos |
      name = super.getName() and
      lastDotPos = max([-1, name.indexOf(".")]) and
      result = name.suffix(lastDotPos + 1)
    )*/
    // match as many characters as possible at the end that are not `.`.
    // (`*?` is lazy matching)
    result = super.getName().regexpCapture(".*?([^\\.]*)", 1)
  }

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
