/**
 * This module provides a hand-modifiable wrapper around the generated class `CfgComposite`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CfgComposite

/**
 * INTERNAL: This module contains the customizable definition of `CfgComposite` and should not
 * be referenced directly.
 */
module Impl {
  class CfgComposite extends Generated::CfgComposite {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
