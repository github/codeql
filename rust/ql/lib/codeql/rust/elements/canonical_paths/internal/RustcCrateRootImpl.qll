/**
 * This module provides a hand-modifiable wrapper around the generated class `RustcCrateRef`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.RustcCrateRef

/**
 * INTERNAL: This module contains the customizable definition of `RustcCrateRef` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference to a crate provided by rustc. TODO: understand where these come from.
   */
  class RustcCrateRef extends Generated::RustcCrateRef {
    override string toAbbreviatedString() { result = this.getName() }
  }
}
