/**
 * This module provides a hand-modifiable wrapper around the generated class `TypeImplItemCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.TypeImplItemCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `TypeImplItemCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A canonical path for an item defined in a type impl.
   */
  class TypeImplItemCanonicalPath extends Generated::TypeImplItemCanonicalPath {
    override string toString() {
      result = "<" + this.getParent().toAbbreviatedString() + ">::" + this.getName()
    }
  }
}
