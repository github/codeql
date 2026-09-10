/**
 * This module provides a hand-modifiable wrapper around the generated class `PathMeta`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PathMeta

/**
 * INTERNAL: This module contains the customizable definition of `PathMeta` and should not
 * be referenced directly.
 */
module Impl {
  class PathMeta extends Generated::PathMeta {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
