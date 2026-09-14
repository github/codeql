/**
 * This module provides a hand-modifiable wrapper around the generated class `ImplRestriction`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ImplRestriction

/**
 * INTERNAL: This module contains the customizable definition of `ImplRestriction` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An implementation restriction, limiting where a trait can be implemented. For example the `impl(crate)` restriction (an unstable feature).
   */
  class ImplRestriction extends Generated::ImplRestriction {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
