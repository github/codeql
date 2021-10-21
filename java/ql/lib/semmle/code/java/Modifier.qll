/**
 * Provides classes and predicates for working with Java modifiers.
 */

import Element

/** A modifier such as `private`, `static` or `abstract`. */
class Modifier extends Element, @modifier {
  /** Gets the element to which this modifier applies. */
  Element getElement() { hasModifier(result, this) }

  override string getAPrimaryQlClass() { result = "Modifier" }
}

/** An element of the Java syntax tree that may have a modifier. */
abstract class Modifiable extends Element {
  /**
   * Holds if this element has modifier `m`.
   *
   * For most purposes, the more specialized predicates `isAbstract`, `isPublic`, etc.
   * should be used.
   *
   * Both this method and those specialized predicates take implicit modifiers into account.
   * For instance, non-default instance methods in interfaces are implicitly
   * abstract, so `isAbstract()` will hold for them even if `hasModifier("abstract")`
   * does not.
   */
  predicate hasModifier(string m) { modifiers(this.getAModifier(), m) }

  /** Holds if this element has no modifier. */
  predicate hasNoModifier() { not hasModifier(this, _) }

  /** Gets a modifier of this element. */
  Modifier getAModifier() { this = result.getElement() }

  /** Holds if this element has an `abstract` modifier or is implicitly abstract. */
  predicate isAbstract() { this.hasModifier("abstract") }

  /** Holds if this element has a `static` modifier or is implicitly static. */
  predicate isStatic() { this.hasModifier("static") }

  /** Holds if this element has a `final` modifier or is implicitly final. */
  predicate isFinal() { this.hasModifier("final") }

  /** Holds if this element has a `public` modifier or is implicitly public. */
  predicate isPublic() { this.hasModifier("public") }

  /** Holds if this element has a `protected` modifier. */
  predicate isProtected() { this.hasModifier("protected") }

  /** Holds if this element has a `private` modifier or is implicitly private. */
  predicate isPrivate() { this.hasModifier("private") }

  /** Holds if this element has a `volatile` modifier. */
  predicate isVolatile() { this.hasModifier("volatile") }

  /** Holds if this element has a `synchronized` modifier. */
  predicate isSynchronized() { this.hasModifier("synchronized") }

  /** Holds if this element has a `native` modifier. */
  predicate isNative() { this.hasModifier("native") }

  /** Holds if this element has a `default` modifier. */
  predicate isDefault() { this.hasModifier("default") }

  /** Holds if this element has a `transient` modifier. */
  predicate isTransient() { this.hasModifier("transient") }

  /** Holds if this element has a `strictfp` modifier. */
  predicate isStrictfp() { this.hasModifier("strictfp") }
}
