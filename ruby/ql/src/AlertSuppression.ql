/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id rb/alert-suppression
 */

import ruby
import codeql.ruby.ast.internal.TreeSitter

/**
 * An alert suppression comment.
 */
class SuppressionComment extends Ruby::Comment {
  string annotation;

  SuppressionComment() {
    // suppression comments must be single-line
    this.getLocation().getStartLine() = this.getLocation().getEndLine() and
    exists(string text | text = commentText(this) |
      // match `lgtm[...]` anywhere in the comment
      annotation = text.regexpFind("(?i)\\blgtm\\s*\\[[^\\]]*\\]", _, _)
      or
      // match `lgtm` at the start of the comment and after semicolon
      annotation = text.regexpFind("(?i)(?<=^|;)\\s*lgtm(?!\\B|\\s*\\[)", _, _).trim()
    )
  }

  /**
   * Gets the text of this suppression comment.
   */
  string getText() { result = commentText(this) }

  /** Gets the suppression annotation in this comment. */
  string getAnnotation() { result = annotation }

  /**
   * Holds if this comment applies to the range from column `startcolumn` of line `startline`
   * to column `endcolumn` of line `endline` in file `filepath`.
   */
  predicate covers(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    this.getLocation().hasLocationInfo(filepath, startline, _, endline, endcolumn) and
    startcolumn = 1
  }

  /** Gets the scope of this suppression. */
  SuppressionScope getScope() { this = result.getSuppressionComment() }
}

private string commentText(Ruby::Comment comment) { result = comment.getValue().suffix(1) }

/**
 * The scope of an alert suppression comment.
 */
class SuppressionScope extends @ruby_token_comment {
  SuppressionScope() { this instanceof SuppressionComment }

  /** Gets a suppression comment with this scope. */
  SuppressionComment getSuppressionComment() { result = this }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.(SuppressionComment).covers(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "suppression range" }
}

from SuppressionComment c
select c, // suppression comment
  c.getText(), // text of suppression comment (excluding delimiters)
  c.getAnnotation(), // text of suppression annotation
  c.getScope() // scope of suppression
