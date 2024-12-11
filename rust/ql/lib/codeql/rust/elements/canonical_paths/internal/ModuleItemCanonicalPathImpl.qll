/**
 * This module provides a hand-modifiable wrapper around the generated class `ModuleItemCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.ModuleItemCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `ModuleItemCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A canonical path for an item defined in a module.
   */
  class ModuleItemCanonicalPath extends Generated::ModuleItemCanonicalPath {
    override string toString() {
      result = this.getNamespace().toAbbreviatedString() + "::" + this.getName()
    }

    override predicate hasStandardPath(string namespace, string name) {
      this.getName() = name and namespace = this.getNamespace().getNamespaceString()
    }
  }
}
