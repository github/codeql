/**
 * @name Alert suppression using annotations
 * @description Generates information about alert suppressions
 *              using 'SuppressWarnings' annotations.
 * @kind alert-suppression
 * @id java/alert-suppression-annotations
 */

import java
import Metrics.Internal.Extents

/**
 * An alert suppression annotation.
 */
class SuppressionAnnotation extends SuppressWarningsAnnotation {
  string annotation;

  SuppressionAnnotation() {
    exists(string text | text = this.getASuppressedWarningLiteral().getValue() |
      // match `lgtm[...]` anywhere in the comment
      annotation = text.regexpFind("(?i)\\blgtm\\s*\\[[^\\]]*\\]", _, _)
    )
  }

  /**
   * Gets the text of this suppression annotation.
   */
  string getText() { result = getASuppressedWarningLiteral().getValue() }

  /** Gets the LGTM suppression annotation in this Java annotation. */
  string getAnnotation() { result = annotation }

  /**
   * Holds if this annotation applies to the range from column `startcolumn` of line `startline`
   * to column `endcolumn` of line `endline` in file `filepath`.
   */
  predicate covers(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    getAnnotatedElement().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the scope of this suppression. */
  SuppressionScope getScope() { this = result.getSuppressionAnnotation() }
}

/**
 * The scope of an alert suppression annotation.
 */
class SuppressionScope extends @annotation {
  SuppressionScope() { this instanceof SuppressionAnnotation }

  /** Gets a suppression annotation with this scope. */
  SuppressionAnnotation getSuppressionAnnotation() { result = this }

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
    this.(SuppressionAnnotation).covers(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "suppression range" }
}

from SuppressionAnnotation c
select c, // suppression comment
  c.getText(), // text of suppression comment (excluding delimiters)
  c.getAnnotation(), // text of suppression annotation
  c.getScope() // scope of suppression
