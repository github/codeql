/**
 * This module provides a hand-modifiable wrapper around the generated class `LangCrateRoot`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.LangCrateRoot

/**
 * INTERNAL: This module contains the customizable definition of `LangCrateRoot` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference to a crate in the Rust standard libraries.
   */
  class LangCrateRoot extends Generated::LangCrateRoot {
    override string toAbbreviatedString() { result = this.getName() }
  }
}
