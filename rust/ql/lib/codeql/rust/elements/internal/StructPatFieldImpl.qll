/**
 * This module provides a hand-modifiable wrapper around the generated class `StructPatField`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.StructPatField

/**
 * INTERNAL: This module contains the customizable definition of `StructPatField` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A field in a struct pattern. For example `a: 1` in:
   * ```rust
   * let Foo { a: 1, b: 2 } = foo;
   * ```
   */
  class StructPatField extends Generated::StructPatField {
    override string toStringImpl() { result = concat(int i | | this.toStringPart(i) order by i) }

    private string toStringPart(int index) {
      index = 0 and result = this.getNameRef().getText()
      or
      index = 1 and this.hasNameRef() and result = ": "
      or
      index = 2 and
      result = this.getPat().toAbbreviatedString()
    }

    /**
     * Gets the name of the field. This includes the case when shorthand syntax is used:
     *
     * ```rust
     * match foo {
     *   Foo { x: a, .. } => ..., // field name is `x`
     *   Bar { y, .. } => ...     // field name is `y`
     * }
     * ```
     */
    string getFieldName() {
      result = this.getNameRef().getText()
      or
      not this.hasNameRef() and
      result = this.getPat().(IdentPat).getName().getText()
    }
  }
}
