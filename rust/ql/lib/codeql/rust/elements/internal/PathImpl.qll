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
   * use some_crate::some_module::some_item;
   * foo::bar;
   * ```
   */
  class Path extends Generated::Path {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() {
      if this.hasQualifier()
      then result = "...::" + this.getPart().toAbbreviatedString()
      else result = this.getPart().toAbbreviatedString()
    }

    /**
     * Gets the text of this path, if it exists.
     */
    pragma[nomagic]
    string getText() { result = this.getPart().getNameRef().getText() }
  }
}
