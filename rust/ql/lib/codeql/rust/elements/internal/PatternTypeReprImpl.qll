/**
 * This module provides a hand-modifiable wrapper around the generated class `PatternTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PatternTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `PatternTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A pattern type, constraining a type to values matching a pattern. Pattern types are an
   * experimental, mostly compiler-internal feature and cannot be written directly in stable
   * Rust; the example below uses rust-analyzer's canonical `builtin#pattern_type` syntax:
   * ```rust
   * type NonZero = builtin#pattern_type(u32 is 1..);
   * ```
   */
  class PatternTypeRepr extends Generated::PatternTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
