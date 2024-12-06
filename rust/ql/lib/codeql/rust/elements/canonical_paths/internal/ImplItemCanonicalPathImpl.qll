/**
 * This module provides a hand-modifiable wrapper around the generated class `ImplItemCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.ImplItemCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `ImplItemCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A canonical path for an item defined in an impl (a method or associated type).
   */
  class ImplItemCanonicalPath extends Generated::ImplItemCanonicalPath {
    override string toString() {
      exists(string trait |
        (
          if this.hasTraitPath()
          then trait = " as " + this.getTraitPath().toAbbreviatedString()
          else trait = ""
        ) and
        result = "<" + this.getTypePath().toAbbreviatedString() + trait + ">::" + this.getName()
      )
    }
  }
}
