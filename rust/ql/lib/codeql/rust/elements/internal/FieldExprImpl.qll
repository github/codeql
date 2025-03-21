/**
 * This module provides a hand-modifiable wrapper around the generated class `FieldExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.FieldExpr

/**
 * INTERNAL: This module contains the customizable definition of `FieldExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.TypeInference as TypeInference

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A field access expression. For example:
   * ```rust
   * x.foo
   * ```
   */
  class FieldExpr extends Generated::FieldExpr {
    /** Gets the record field that this access references, if any. */
    StructField getStructField() { result = TypeInference::resolveStructFieldExpr(this) }

    /** Gets the tuple field that this access references, if any. */
    TupleField getTupleField() { result = TypeInference::resolveTupleFieldExpr(this) }

    override string toStringImpl() {
      exists(string abbr, string name |
        abbr = this.getExpr().toAbbreviatedString() and
        name = this.getNameRef().getText() and
        if abbr = "..." then result = "... ." + name else result = abbr + "." + name
      )
    }
  }
}
