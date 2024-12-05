/**
 * This module provides a hand-modifiable wrapper around the generated class `RepoCrateRoot`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.RepoCrateRoot

/**
 * INTERNAL: This module contains the customizable definition of `RepoCrateRoot` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference to a crate in the repository.
   */
  class RepoCrateRoot extends Generated::RepoCrateRoot {
    override string toAbbreviatedString() {
      result = this.getName()
      or
      not this.hasName() and result = "<unnamed>"
    }
  }
}
