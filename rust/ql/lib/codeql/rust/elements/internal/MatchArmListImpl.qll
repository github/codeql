/**
 * This module provides a hand-modifiable wrapper around the generated class `MatchArmList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MatchArmList

/**
 * INTERNAL: This module contains the customizable definition of `MatchArmList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of arms in a match expression.
   *
   * For example:
   * ```rust
   * match x {
   *     1 => "one",
   *     2 => "two",
   *     _ => "other",
   * }
   * //  ^^^^^^^^^^^
   * ```
   */
  class MatchArmList extends Generated::MatchArmList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
