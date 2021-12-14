/**
 * @name Alert suppression using annotations
 * @description Generates information about alert suppressions
 *              using 'SuppressWarnings' annotations.
 * @kind alert-suppression
 * @id java/alert-suppression-annotations
 */

import java
import Metrics.Internal.Extents

/** Gets the LGTM suppression annotation text in the string `s`, if any. */
bindingset[s]
string getAnnotationText(string s) {
  // match `lgtm[...]` anywhere in the comment
  result = s.regexpFind("(?i)\\blgtm\\s*\\[[^\\]]*\\]", _, _)
}

/**
 * An alert suppression annotation.
 */
class SuppressionAnnotation extends SuppressWarningsAnnotation {
  string text;

  SuppressionAnnotation() {
    text = this.getASuppressedWarningLiteral().getValue() and
    exists(getAnnotationText(text))
  }

  /**
   * Gets the text of this suppression annotation.
   */
  string getText() { result = text }

  private Annotation getASiblingAnnotation() {
    result = this.getAnnotatedElement().(Annotatable).getAnAnnotation() and
    (
      this.getAnnotatedElement() instanceof Callable or
      this.getAnnotatedElement() instanceof RefType
    )
  }

  private Annotation firstAnnotation() {
    result =
      min(this.getASiblingAnnotation() as m
        order by
          m.getLocation().getStartLine(), m.getLocation().getStartColumn()
      )
  }

  /**
   * Holds if this annotation applies to the range from column `startcolumn` of line `startline`
   * to column `endcolumn` of line `endline` in file `filepath`.
   */
  predicate covers(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    if this.firstAnnotation().hasLocationInfo(filepath, _, _, _, _)
    then
      this.getAnnotatedElement().hasLocationInfo(filepath, _, _, endline, endcolumn) and
      this.firstAnnotation().hasLocationInfo(filepath, startline, startcolumn, _, _)
    else
      this.getAnnotatedElement()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
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
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.(SuppressionAnnotation).covers(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "suppression range" }
}

from SuppressionAnnotation c, string text, string annotationText
where
  text = c.getText() and
  annotationText = getAnnotationText(text)
select c, // suppression entity
  text, // full text of suppression string
  annotationText, // LGTM suppression annotation text
  c.getScope() // scope of suppression
