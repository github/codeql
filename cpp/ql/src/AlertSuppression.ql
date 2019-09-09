/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id cpp/alert-suppression
 */

import cpp

/**
 * An alert suppression comment.
 */
class SuppressionComment extends CppStyleComment {
  string annotation;
  string text;

  SuppressionComment() {
    text = getContents().suffix(2) and
    (
      // match `lgtm[...]` anywhere in the comment
      annotation = text.regexpFind("(?i)\\blgtm\\s*\\[[^\\]]*\\]", _, _)
      or
      // match `lgtm` at the start of the comment and after semicolon
      annotation = text.regexpFind("(?i)(?<=^|;)\\s*lgtm(?!\\B|\\s*\\[)", _, _).trim()
    )
  }

  /** Gets the text in this comment, excluding the leading //. */
  string getText() { result = text }

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
  SuppressionScope getScope() { result = this }
}

/**
 * The scope of an alert suppression comment.
 */
class SuppressionScope extends ElementBase {
  SuppressionScope() { this instanceof SuppressionComment }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.(SuppressionComment).covers(filepath, startline, startcolumn, endline, endcolumn)
  }
}

from SuppressionComment c
select c, // suppression comment
  c.getText(), // text of suppression comment (excluding delimiters)
  c.getAnnotation(), // text of suppression annotation
  c.getScope() // scope of suppression
