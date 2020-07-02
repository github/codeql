/**
 * Provides classes representing C and C++ comments.
 */

import semmle.code.cpp.Location
import semmle.code.cpp.Element

/**
 * A C/C++ comment. For example the comment in the following code:
 * ```
 * // C++ style single-line comment
 * ```
 * or a C style comment (which starts with `/*`).
 */
class Comment extends Locatable, @comment {
  override string toString() { result = this.getContents() }

  override Location getLocation() { comments(underlyingElement(this), _, result) }

  /**
   * Gets the text of this comment, including the opening `//` or `/*`, and the closing `*``/` if
   * present.
   */
  string getContents() { comments(underlyingElement(this), result, _) }

  /**
   * Gets the AST element this comment is associated with. For example, the comment in the
   * following code is associated with the declaration of `j`.
   * ```
   * int i;
   * int j; // Comment on j
   * ```
   */
  Element getCommentedElement() {
    commentbinding(underlyingElement(this), unresolveElement(result))
  }
}

/**
 * A C style comment (one which starts with `/*`).
 */
class CStyleComment extends Comment {
  CStyleComment() { this.getContents().matches("/*%") }
}

/**
 * A CPP style comment. For example the comment in the following code:
 * ```
 * // C++ style single-line comment
 * ```
 */
class CppStyleComment extends Comment {
  CppStyleComment() { this.getContents().prefix(2) = "//" }
}
