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

    /**
     * Splits the standard path this resolves into into its components (see `CanonicalPath::hasStandardPath/3`).
     */
    predicate resolvesToStandardPath(string namespace, string type, string name) {
      this.getResolvedCanonicalPath().hasStandardPath(namespace, type, name)
    }

    /**
     * Splits the standard path into its components (see `CanonicalPath::hasStandardPath/2`).
     */
    predicate resolvesToStandardPath(string namespace, string name) {
      this.getResolvedCanonicalPath().hasStandardPath(namespace, name)
    }
  }
}
