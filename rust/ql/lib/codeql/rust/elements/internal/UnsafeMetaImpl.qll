/**
 * This module provides a hand-modifiable wrapper around the generated class `UnsafeMeta`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.UnsafeMeta

/**
 * INTERNAL: This module contains the customizable definition of `UnsafeMeta` and should not
 * be referenced directly.
 */
module Impl {
  class UnsafeMeta extends Generated::UnsafeMeta {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
