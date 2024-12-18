/**
 * This module provides a hand-modifiable wrapper around the generated class `Comment`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Comment

/**
 * INTERNAL: This module contains the customizable definition of `Comment` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A comment. For example:
   * ```rust
   * // this is a comment
   * /// This is a doc comment
   * ```
   */
  class Comment extends Generated::Comment {
    override string toString() {
      result = this.getCommentMarker() + "..." + this.getCommentEndMarker()
    }

    /**
     * Gets the text of this comment, excluding the comment markers.
     */
    string getCommentText() {
      exists(string s | s = this.getText() |
        result =
          [
            s.regexpCapture("///?\\s*(.*)", 1),
            s.regexpCapture("(?s)/\\*\\*?\\s*(.*?)\\s*\\*/", 1)
          ]
      )
    }

    /**
     * Gets the marker of this comment, that is `"//"`, `"///"`, `"/*"` or `"/**"`.
     */
    string getCommentMarker() { result = this.getText().regexpCapture("(?s)(///?|/\\*\\*?).*", 1) }

    private string getCommentEndMarker() {
      if this.getCommentMarker() = ["//", "///"] then result = "" else result = "*/"
    }
  }
}
