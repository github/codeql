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
  private import rust

  class Crate extends Generated::Crate {
    override string toString() { result = strictconcat(int i | | this.toStringPart(i) order by i) }

    private string toStringPart(int i) {
      i = 0 and result = "Crate("
      or
      i = 1 and result = this.getName()
      or
      i = 2 and result = "@"
      or
      i = 3 and result = this.getVersion()
      or
      i = 4 and result = ")"
    }

    override Location getLocation() { result = this.getModule().getLocation() }
  }
}
