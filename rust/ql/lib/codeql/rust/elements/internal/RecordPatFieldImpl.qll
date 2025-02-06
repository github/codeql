/**
 * This module provides a hand-modifiable wrapper around the generated class `RecordPatField`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RecordPatField

/**
 * INTERNAL: This module contains the customizable definition of `RecordPatField` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A field in a record pattern. For example `a: 1` in:
   * ```rust
   * let Foo { a: 1, b: 2 } = foo;
   * ```
   */
  class RecordPatField extends Generated::RecordPatField {
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
