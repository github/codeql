/**
 * This module provides a hand-modifiable wrapper around the generated class `MutRestriction`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MutRestriction

/**
 * INTERNAL: This module contains the customizable definition of `MutRestriction` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A mutability restriction, limiting where a field can be mutated. For example the `mut(crate)` restriction (an unstable feature).
   */
  class MutRestriction extends Generated::MutRestriction {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
