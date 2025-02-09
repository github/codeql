/**
 * This module provides a hand-modifiable wrapper around the generated class `RecordPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RecordPat

/**
 * INTERNAL: This module contains the customizable definition of `RecordPat` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import PathResolution as PathResolution

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A record pattern. For example:
   * ```rust
   * match x {
   *     Foo { a: 1, b: 2 } => "ok",
   *     Foo { .. } => "fail",
   * }
   * ```
   */
  class RecordPat extends Generated::RecordPat {
    override string toString() { result = this.getPath().toAbbreviatedString() + " {...}" }

    /** Gets the record field that matches the `name` pattern of this pattern. */
    pragma[nomagic]
    RecordField getRecordField(string name) {
      exists(PathResolution::ItemNode i |
        i = PathResolution::resolvePath(this.getPath()) and
        name = this.getRecordPatFieldList().getAField().getFieldName()
      |
        result.isStructField(i, name) or
        result.isVariantField(i, name)
      )
    }
  }
}
