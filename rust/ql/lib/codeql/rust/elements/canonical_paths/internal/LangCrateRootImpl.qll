/**
 * This module provides a hand-modifiable wrapper around the generated class `LangCrateRef`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.LangCrateRef

/**
 * INTERNAL: This module contains the customizable definition of `LangCrateRef` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference to a crate in the Rust standard libraries.
   */
  class LangCrateRef extends Generated::LangCrateRef {
    override string toAbbreviatedString() { result = this.getName() }
  }
}
