/**
 * This module provides a hand-modifiable wrapper around the generated class `CfgAtom`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CfgAtom

/**
 * INTERNAL: This module contains the customizable definition of `CfgAtom` and should not
 * be referenced directly.
 */
module Impl {
  class CfgAtom extends Generated::CfgAtom {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
