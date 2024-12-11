/**
 * This module provides a hand-modifiable wrapper around the generated class `Resolvable`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Resolvable

/**
 * INTERNAL: This module contains the customizable definition of `Resolvable` and should not
 * be referenced directly.
 */
module Impl {
  private import codeql.rust.elements.internal.ItemImpl::Impl

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * One of `PathExpr`, `RecordExpr`, `PathPat`, `RecordPat`, `TupleStructPat` or `MethodCallExpr`.
   */
  class Resolvable extends Generated::Resolvable {
    /**
     * Holds if this resolvable and the item `i` resolves to the same canonical
     * path
     */
    pragma[nomagic]
    predicate resolvesAsItem(Item i) { this.getResolvedCanonicalPath() = i.getCanonicalPath() }
  }
}
