private import codeql.swift.generated.type.Type

/**
 * A Swift type.
 *
 * This QL class is the root of the Swift type hierarchy.
 */
class Type extends Generated::Type {
  override string toString() { result = this.getFullName() }

  /**
   * Gets the name of this type.
   */
  override string getName() {
    // replace anything that looks like a full name `a.b.c` with just the
    // short name `c`, by removing the `a.` and `b.` parts. Note that this
    // has to be robust for tuple type names such as `(a, b.c)`.
    result = super.getName().regexpReplaceAll("[^(),. ]++\\.(?!\\.)", "")
  }

  /**
   * Gets the full name of this `Type`. For example in:
   * ```swift
   * struct A {
   *   struct B {
   *     // ...
   *   }
   * }
   * ```
   * The name and full name of `A` is `A`. The name of `B` is `B`, but the
   * full name of `B` is `A.B`.
   */
  string getFullName() { result = super.getName() }

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
