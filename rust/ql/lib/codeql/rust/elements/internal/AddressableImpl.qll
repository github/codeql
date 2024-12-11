/**
 * This module provides a hand-modifiable wrapper around the generated class `Addressable`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Addressable

/**
 * INTERNAL: This module contains the customizable definition of `Addressable` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * Something that can be addressed by a path.
   *
   * TODO: This does not yet include all possible cases.
   */
  class Addressable extends Generated::Addressable {
    /**
     * Splits the standard path into its components (see `CanonicalPath::hasStandardPath/3`).
     */
    predicate hasStandardPath(string namespace, string type, string name) {
      this.getCanonicalPath().hasStandardPath(namespace, type, name)
    }

    /**
     * Splits the standard path into its components (see `CanonicalPath::hasStandardPath/2`).
     */
    predicate hasStandardPath(string namespace, string name) {
      this.getCanonicalPath().hasStandardPath(namespace, name)
    }
  }
}
