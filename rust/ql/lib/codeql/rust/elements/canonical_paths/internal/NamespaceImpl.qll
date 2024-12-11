/**
 * This module provides a hand-modifiable wrapper around the generated class `Namespace`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.Namespace

/**
 * INTERNAL: This module contains the customizable definition of `Namespace` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A namespace, comprised of a crate root and a possibly empty `::` separated module path.
   */
  class Namespace extends Generated::Namespace {
    override string toString() {
      exists(string root |
        root = this.getRoot().toString() and
        if this.getPath() = "" then result = root else result = root + "::" + this.getPath()
      )
    }

    /**
     * Returns a string representation of this namespace, with the root and path separated by `::`.
     */
    cached
    string getNamespaceString() {
      exists(string root, string path |
        root = this.getRoot().toString() and
        path = this.getPath() and
        if path = "" then result = root else result = root + "::" + path
      )
    }
  }
}
