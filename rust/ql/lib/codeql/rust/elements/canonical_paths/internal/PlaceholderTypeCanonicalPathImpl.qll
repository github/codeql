/**
 * This module provides a hand-modifiable wrapper around the generated class `PlaceholderTypeCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.PlaceholderTypeCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `PlaceholderTypeCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A placeholder for a type parameter bound in an impl.
   */
  class PlaceholderTypeCanonicalPath extends Generated::PlaceholderTypeCanonicalPath {
    override string toAbbreviatedString() { result = "_" }

    override string toString() { result = "_" }
  }
}
