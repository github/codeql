/**
 * This module provides a hand-modifiable wrapper around the generated class `CrateRoot`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.CrateRoot

/**
 * INTERNAL: This module contains the customizable definition of `CrateRoot` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for all crate references.
   */
  class CrateRoot extends Generated::CrateRoot {
    override string toString() { result = this.toAbbreviatedString() }
  }
}
