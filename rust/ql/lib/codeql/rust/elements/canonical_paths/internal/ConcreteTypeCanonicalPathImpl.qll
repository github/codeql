/**
 * This module provides a hand-modifiable wrapper around the generated class `ConcreteTypeCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.ConcreteTypeCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `ConcreteTypeCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A canonical path for an actual type.
   */
  class ConcreteTypeCanonicalPath extends Generated::ConcreteTypeCanonicalPath {
    override string toString() { result = this.getPath().toAbbreviatedString() }
  }
}
