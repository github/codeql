/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id py/alert-suppression
 */

import python

/**
 * An alert suppression comment.
 */
abstract class SuppressionComment extends Comment {
  /** Gets the scope of this suppression. */
  abstract SuppressionScope getScope();

  /** Gets the suppression annotation in this comment. */
  abstract string getAnnotation();

  /**
   * Holds if this comment applies to the range from column `startcolumn` of line `startline`
   * to column `endcolumn` of line `endline` in file `filepath`.
   */
  abstract predicate covers(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  );
}

/**
 * An alert comment that applies to a single line
 */
abstract class LineSuppressionComment extends SuppressionComment {
  LineSuppressionComment() {
    exists(string filepath, int l |
      this.getLocation().hasLocationInfo(filepath, l, _, _, _) and
      any(AstNode a).getLocation().hasLocationInfo(filepath, l, _, _, _)
    )
  }

  /** Gets the scope of this suppression. */
  override SuppressionScope getScope() { result = this }

  override predicate covers(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, _, endline, endcolumn) and
    startcolumn = 1
  }
}

/**
 * An lgtm suppression comment.
 */
class LgtmSuppressionComment extends LineSuppressionComment {
  string annotation;

  LgtmSuppressionComment() {
    exists(string all | all = this.getContents() |
      // match `lgtm[...]` anywhere in the comment
      annotation = all.regexpFind("(?i)\\blgtm\\s*\\[[^\\]]*\\]", _, _)
      or
      // match `lgtm` at the start of the comment and after semicolon
      annotation = all.regexpFind("(?i)(?<=^|;)\\s*lgtm(?!\\B|\\s*\\[)", _, _).trim()
    )
  }

  /** Gets the suppression annotation in this comment. */
  override string getAnnotation() { result = annotation }
}

/**
 * A noqa suppression comment. Both pylint and pyflakes respect this, so lgtm ought to too.
 */
class NoqaSuppressionComment extends LineSuppressionComment {
  NoqaSuppressionComment() { this.getContents().toLowerCase().regexpMatch("\\s*noqa\\s*") }

  override string getAnnotation() { result = "lgtm" }
}

/**
 * The scope of an alert suppression comment.
 */
class SuppressionScope extends @py_comment {
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

  /** Gets a textual representation of this element. */
  string toString() { result = "suppression range" }
}

from SuppressionComment c
select c, // suppression comment
  c.getContents(), // text of suppression comment (excluding delimiters)
  c.getAnnotation(), // text of suppression annotation
  c.getScope() // scope of suppression
