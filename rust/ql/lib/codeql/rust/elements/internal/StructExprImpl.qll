/**
 * This module provides a hand-modifiable wrapper around the generated class `StructExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.StructExpr

/**
 * INTERNAL: This module contains the customizable definition of `StructExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.PathResolution as PathResolution

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A struct expression. For example:
   * ```rust
   * let first = Foo { a: 1, b: 2 };
   * let second = Foo { a: 2, ..first };
   * let n = Foo { a: 1, b: 2 }.b;
   * Foo { a: m, .. } = second;
   * ```
   */
  class StructExpr extends Generated::StructExpr {
    override string toStringImpl() { result = this.getPath().toStringImpl() + " {...}" }

    /** Gets the record expression for the field `name`. */
    pragma[nomagic]
    StructExprField getFieldExpr(string name) {
      result = this.getStructExprFieldList().getAField() and
      name = result.getFieldName()
    }

    pragma[nomagic]
    private PathResolution::ItemNode getResolvedPath(string name) {
      result = PathResolution::resolvePath(this.getPath()) and
      exists(this.getFieldExpr(name))
    }

    /** Gets the record field that matches the `name` field of this record expression. */
    pragma[nomagic]
    StructField getStructField(string name) {
      exists(PathResolution::ItemNode i | i = this.getResolvedPath(name) |
        result.isStructField(i, name) or
        result.isVariantField(i, name)
      )
    }
  }
}
