/**
 * This module provides a hand-modifiable wrapper around the generated class `Path`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Path

/**
 * INTERNAL: This module contains the customizable definition of `Path` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A path. For example:
   * ```rust
   * foo::bar;
   * ```
   */
  class Path extends Generated::Path {
    override string toString() {
      if this.hasQualifier()
      then result = this.getQualifier().toString() + "::" + this.getPart().toString()
      else result = this.getPart().toString()
    }
  }
}
