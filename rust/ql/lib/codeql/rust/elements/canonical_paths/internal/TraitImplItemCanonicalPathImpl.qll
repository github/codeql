/**
 * This module provides a hand-modifiable wrapper around the generated class `TraitImplItemCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.TraitImplItemCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `TraitImplItemCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A canonical path for an item defined in a trait impl.
   */
  class TraitImplItemCanonicalPath extends Generated::TraitImplItemCanonicalPath {
    override string toString() {
      result =
        "<" + this.getTypePath().toAbbreviatedString() + " as " +
          this.getTraitPath().toAbbreviatedString() + ">::" + this.getName()
    }
  }
}
