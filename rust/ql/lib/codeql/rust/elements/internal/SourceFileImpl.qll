/**
 * This module provides a hand-modifiable wrapper around the generated class `SourceFile`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.SourceFile

/**
 * INTERNAL: This module contains the customizable definition of `SourceFile` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A source file.
   *
   * For example:
   * ```rust
   * // main.rs
   * fn main() {}
   * ```
   */
  class SourceFile extends Generated::SourceFile {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
