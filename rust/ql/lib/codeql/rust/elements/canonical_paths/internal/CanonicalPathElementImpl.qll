/**
 * This module provides a hand-modifiable wrapper around the generated class `CanonicalPathElement`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.CanonicalPathElement

/**
 * INTERNAL: This module contains the customizable definition of `CanonicalPathElement` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for all elements in a canonical path.
   */
  class CanonicalPathElement extends Generated::CanonicalPathElement {
    override string toString() { result = "?" }
  }
}
