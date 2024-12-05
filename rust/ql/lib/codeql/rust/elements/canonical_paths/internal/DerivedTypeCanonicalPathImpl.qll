/**
 * This module provides a hand-modifiable wrapper around the generated class `DerivedTypeCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.DerivedTypeCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `DerivedTypeCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A derived canonical type, like `[i32; 4]`, `&mut std::string::String` or `(i32, std::string::String)`.
   */
  class DerivedTypeCanonicalPath extends Generated::DerivedTypeCanonicalPath {
    override string toString() {
      result =
        this.getModifier() + "(" +
          strictconcat(int i | | this.getBase(i).toAbbreviatedString(), ", " order by i) + ")"
    }
  }
}
