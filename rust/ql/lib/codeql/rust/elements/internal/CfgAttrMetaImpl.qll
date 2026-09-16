/**
 * This module provides a hand-modifiable wrapper around the generated class `CfgAttrMeta`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CfgAttrMeta

/**
 * INTERNAL: This module contains the customizable definition of `CfgAttrMeta` and should not
 * be referenced directly.
 */
module Impl {
  class CfgAttrMeta extends Generated::CfgAttrMeta {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
