/**
 * Provides classes that represent standard annotations from the JDK.
 */

import java

/** A `@Deprecated` annotation. */
class DeprecatedAnnotation extends Annotation {
  DeprecatedAnnotation() { this.getType().hasQualifiedName("java.lang", "Deprecated") }
}

/** An `@Override` annotation. */
class OverrideAnnotation extends Annotation {
  OverrideAnnotation() { this.getType().hasQualifiedName("java.lang", "Override") }
}

/** A `@SuppressWarnings` annotation. */
class SuppressWarningsAnnotation extends Annotation {
  SuppressWarningsAnnotation() { this.getType().hasQualifiedName("java.lang", "SuppressWarnings") }

  /**
   * DEPRECATED: This predicate restricts the results to `StringLiteral`; prefer `getASuppressedWarning()`
   * to get the name of a suppressed warning.
   *
   * Gets the `StringLiteral` of a warning suppressed by this annotation.
   */
  deprecated StringLiteral getASuppressedWarningLiteral() { result = this.getAnArrayValue("value") }

  /** Gets the name of a warning suppressed by this annotation. */
  string getASuppressedWarning() { result = this.getAStringArrayValue("value") }
}

/** A `@Target` annotation. */
class TargetAnnotation extends Annotation {
  TargetAnnotation() { this.getType().hasQualifiedName("java.lang.annotation", "Target") }

  /**
   * DEPRECATED: Getting the field access expression is rarely useful. Use `getATargetElementType()`
   * to get the name of the target element.
   *
   * Gets a target expression within this annotation.
   *
   * For example, the field access `ElementType.FIELD` is a target expression in
   * `@Target({ElementType.FIELD, ElementType.METHOD})`.
   */
  deprecated Expr getATargetExpression() { result = this.getAnArrayValue("value") }

  /**
   * Gets the name of a target element type.
   *
   * For example, `METHOD` is the name of a target element type in
   * `@Target({ElementType.FIELD, ElementType.METHOD})`.
   */
  string getATargetElementType() { result = this.getAnEnumConstantArrayValue("value").getName() }
}

/** A `@Retention` annotation. */
class RetentionAnnotation extends Annotation {
  RetentionAnnotation() { this.getType().hasQualifiedName("java.lang.annotation", "Retention") }

  /**
   * DEPRECATED: Getting the field access expression is rarely useful. Use `getRetentionPolicy()`
   * to get the name of the retention policy.
   *
   * Gets the retention policy expression within this annotation.
   *
   * For example, the field access `RetentionPolicy.RUNTIME` is the
   * retention policy expression in `@Retention(RetentionPolicy.RUNTIME)`.
   */
  deprecated Expr getRetentionPolicyExpression() { result = this.getValue("value") }

  /**
   * Gets the name of the retention policy of this annotation.
   *
   * For example, `RUNTIME` is the name of the retention policy
   * in `@Retention(RetentionPolicy.RUNTIME)`.
   */
  string getRetentionPolicy() { result = this.getEnumConstantValue("value").getName() }
}

/** A `@Repeatable` annotation. */
class RepeatableAnnotation extends Annotation {
  RepeatableAnnotation() { this.getType().hasQualifiedName("java.lang.annotation", "Repeatable") }

  /**
   * Gets the annotation type which acts as _containing type_, grouping multiple
   * repeatable annotations together.
   */
  AnnotationType getContainingType() { result = this.getTypeValue("value") }
}

/**
 * An annotation suggesting that the annotated element may be accessed reflectively.
 *
 * This is implemented by negation of a white-list of standard annotations that are
 * known not to be reflection-related; all other annotations are assumed to potentially
 * be reflection-related.
 *
 * A typical use-case is the exclusion of results relating to various frameworks,
 * where an exhaustive list of all annotations for all frameworks that may exist
 * can be difficult to obtain and maintain.
 */
class ReflectiveAccessAnnotation extends Annotation {
  ReflectiveAccessAnnotation() {
    // We conservatively white-list a few standard annotations that have nothing to do
    // with reflection, and assume that any other annotation may be reflection-related.
    not this instanceof NonReflectiveAnnotation
  }
}

/**
 * An annotation that does not indicate that a field may be accessed reflectively.
 *
 * Any annotation that is not a subclass of `NonReflectiveAnnotation` is assumed to
 * allow for reflective access.
 */
abstract class NonReflectiveAnnotation extends Annotation { }

library class StandardNonReflectiveAnnotation extends NonReflectiveAnnotation {
  StandardNonReflectiveAnnotation() {
    this.getType()
        .hasQualifiedName("java.lang", ["Override", "Deprecated", "SuppressWarnings", "SafeVarargs"])
  }
}
