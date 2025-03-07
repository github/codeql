/**
 * This module provides a hand-modifiable wrapper around the generated class `Crate`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Crate

/**
 * INTERNAL: This module contains the customizable definition of `Crate` and should not
 * be referenced directly.
 */
module Impl {
  class Crate extends Generated::Crate {
    override string toString() {
      result = "Crate(" + this.getName() + "@" + concat(this.getVersion()) + ")"
    }
  }
}
