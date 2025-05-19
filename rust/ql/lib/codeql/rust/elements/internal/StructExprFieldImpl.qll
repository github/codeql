/**
 * This module provides a hand-modifiable wrapper around the generated class `StructExprField`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.StructExprField

/**
 * INTERNAL: This module contains the customizable definition of `StructExprField` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.PathImpl::Impl as PathImpl

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A field in a struct expression. For example `a: 1` in:
   * ```rust
   * Foo { a: 1, b: 2 };
   * ```
   */
  class StructExprField extends Generated::StructExprField {
    override string toStringImpl() { result = concat(int i | | this.toStringPart(i) order by i) }

    private string toStringPart(int index) {
      index = 0 and result = this.getIdentifier().getText()
      or
      index = 1 and this.hasIdentifier() and result = ": "
      or
      index = 2 and
      result = this.getExpr().toAbbreviatedString()
    }

    /**
     * Gets the name of the field. This includes the case when shorthand syntax is used:
     *
     * ```rust
     * Foo {
     *   a: 1, // field name is `a`
     *   b     // field name is `b`
     * }
     * ```
     */
    string getFieldName() {
      result = this.getIdentifier().getText()
      or
      not this.hasIdentifier() and
      result = this.getExpr().(PathExpr).getPath().(PathImpl::IdentPath).getName()
    }
  }
}
