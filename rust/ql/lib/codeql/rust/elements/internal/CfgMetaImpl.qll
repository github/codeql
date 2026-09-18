/**
 * This module provides a hand-modifiable wrapper around the generated class `CfgMeta`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CfgMeta

/**
 * INTERNAL: This module contains the customizable definition of `CfgMeta` and should not
 * be referenced directly.
 */
module Impl {
  class CfgMeta extends Generated::CfgMeta {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
