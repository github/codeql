/**
 * This module provides a hand-modifiable wrapper around the generated class `TokenTreeMeta`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TokenTreeMeta

/**
 * INTERNAL: This module contains the customizable definition of `TokenTreeMeta` and should not
 * be referenced directly.
 */
module Impl {
  class TokenTreeMeta extends Generated::TokenTreeMeta {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
