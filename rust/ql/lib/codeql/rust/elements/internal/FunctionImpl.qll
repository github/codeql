/**
 * This module provides a hand-modifiable wrapper around the generated class `Function`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Function
private import codeql.rust.elements.Comment

/**
 * INTERNAL: This module contains the customizable definition of `Function` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A function declaration. For example
   * ```rust
   * fn foo(x: u32) -> u64 {(x + 1).into()}
   * ```
   * A function declaration within a trait might not have a body:
   * ```rust
   * trait Trait {
   *     fn bar();
   * }
   * ```
   */
  class Function extends Generated::Function {
    override string toStringImpl() { result = "fn " + this.getName().getText() }

    /**
     * Gets a comment preceding this function.
     *
     * A comment is considered preceding if it occurs immediately before this
     * function or if only other comments occur between the comment and this
     * function.
     */
    Comment getPrecedingComment() {
      result.getLocation().getFile() = this.getLocation().getFile() and
      // When a function is preceded by comments its start line is the line of
      // the first comment. Hence all relevant comments are found by including
      // comments from the start line and up to the line with the function
      // name.
      this.getLocation().getStartLine() <= result.getLocation().getStartLine() and
      result.getLocation().getStartLine() <= this.getName().getLocation().getStartLine()
    }
  }
}
