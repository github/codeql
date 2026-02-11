/**
 * This module provides a hand-modifiable wrapper around the generated class `AssocItem`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AssocItem

/**
 * INTERNAL: This module contains the customizable definition of `AssocItem` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.PathResolution

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An associated item in a `Trait` or `Impl`.
   *
   * For example:
   * ```rust
   * trait T {fn foo(&self);}
   * //       ^^^^^^^^^^^^^
   * ```
   */
  class AssocItem extends Generated::AssocItem {
    /** Holds if this item implements trait item `other`. */
    pragma[nomagic]
    predicate implements(AssocItem other) {
      exists(TraitItemNode t, ImplItemNode i, string name |
        other = t.getAssocItem(pragma[only_bind_into](name)) and
        t = i.resolveTraitTy() and
        this = i.getAssocItem(pragma[only_bind_into](name))
      )
    }
  }
}
