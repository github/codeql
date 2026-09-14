/**
 * This module provides a hand-modifiable wrapper around the generated class `NamedCrate`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.NamedCrate

/**
 * INTERNAL: This module contains the customizable definition of `NamedCrate` and should not
 * be referenced directly.
 */
module Impl {
  class NamedCrate extends Generated::NamedCrate {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
