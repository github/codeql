/**
 * This module provides a hand-modifiable wrapper around the generated class `RustcCrateRoot`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.RustcCrateRoot

/**
 * INTERNAL: This module contains the customizable definition of `RustcCrateRoot` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference to a crate provided by rustc. TODO: understand where these come from.
   */
  class RustcCrateRoot extends Generated::RustcCrateRoot {
    override string toAbbreviatedString() { result = this.getName() }
  }
}
