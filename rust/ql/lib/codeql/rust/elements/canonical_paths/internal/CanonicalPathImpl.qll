/**
 * This module provides a hand-modifiable wrapper around the generated class `CanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.CanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `CanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for all canonical paths that can be the result of a path resolution.
   */
  class CanonicalPath extends Generated::CanonicalPath {
    /**
     * If this canonical path is of the form `crate::mod1::mod2::Type::name`, then this predicate
     * splits it into its components `crate::mod1::mod2`, `Type` and `name`. This applies to
     * type, trait and type impl items, not to module items (see `hasStandardPath/2`) nor to
     * trait impl items (TODO).
     */
    predicate hasStandardPath(string namespace, string type, string name) { none() }

    /**
     * If this canonical path is of the form `crate::mod1::mod2::name`, then this predicate
     * splits it into its components `crate::mod1::mod2` and `name`. This applies to
     * module items, but not to type, trait and type impl items (see `hasStandardPath/3`) nor to
     * trait impl items (TODO).
     */
    predicate hasStandardPath(string namespace, string name) { none() }
  }
}
