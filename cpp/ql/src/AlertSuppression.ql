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
class SuppressionComment extends Comment {
  string annotation;
  string text;

  SuppressionComment() {
    (
      this instanceof CppStyleComment and
      // strip the beginning slashes
      text = this.getContents().suffix(2)
      or
      this instanceof CStyleComment and
      // strip both the beginning /* and the end */ the comment
      exists(string text0 |
        text0 = this.getContents().suffix(2) and
        text = text0.prefix(text0.length() - 2)
      ) and
      // The /* */ comment must be a single-line comment
      not text.matches("%\n%")
    ) and
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
class SuppressionScope extends ElementBase instanceof SuppressionComment {
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
    super.covers(filepath, startline, startcolumn, endline, endcolumn)
  }
}

from SuppressionComment c
select c, // suppression comment
  c.getText(), // text of suppression comment (excluding delimiters)
  c.getAnnotation(), // text of suppression annotation
  c.getScope() // scope of suppression
