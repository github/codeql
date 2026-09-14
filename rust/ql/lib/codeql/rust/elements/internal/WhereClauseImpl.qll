/**
 * This module provides a hand-modifiable wrapper around the generated class `WhereClause`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.WhereClause

/**
 * INTERNAL: This module contains the customizable definition of `WhereClause` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A where clause in a generic declaration.
   *
   * For example:
   * ```rust
   * fn foo<T>(t: T) where T: Debug {}
   * //              ^^^^^^^^^^^^^^
   * ```
   */
  class WhereClause extends Generated::WhereClause {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
