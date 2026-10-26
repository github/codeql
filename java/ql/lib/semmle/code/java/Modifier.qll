/**
 * Provides classes and predicates for working with Java modifiers.
 */
overlay[local?]
module;

import Element

/** A modifier such as `private`, `static` or `abstract`. */
class Modifier extends Element, @modifier {
  /** Gets the element to which this modifier applies. */
  Element getElement() {
    hasModifier(result, this) and
    // Kotlin "internal" elements may also get "public" modifiers, so we want to filter those out
    not exists(Modifier mod2 |
      hasModifier(result, mod2) and modifiers(this, "public") and modifiers(mod2, "internal")
    )
  }

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
   * Those specialized predicates also take implicit modifiers into account.
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

  /** Holds if this element has a `sealed` modifier. */
  // TODO: `isSealed()` conflicts with `ClassOrInterface.isSealed()`. What name do we want to use here?
  predicate isSealedKotlin() { this.hasModifier("sealed") }

  /** Holds if this element has a `public` modifier or is implicitly public. */
  predicate isPublic() { this.hasModifier("public") }

  /** Holds if this element has a `protected` modifier. */
  predicate isProtected() { this.hasModifier("protected") }

  /** Holds if this element has a `private` modifier or is implicitly private. */
  predicate isPrivate() { this.hasModifier("private") }

  /** Holds if this element has an `internal` modifier. */
  predicate isInternal() { this.hasModifier("internal") }

  /** Holds if this element has an `inline` modifier. */
  predicate isInline() { this.hasModifier("inline") }

  /** Holds if this element has a `noinline` modifier. */
  predicate isNoinline() { this.hasModifier("noinline") }

  /** Holds if this element has a `crossinline` modifier. */
  predicate isCrossinline() { this.hasModifier("crossinline") }

  /** Holds if this element has a `suspend` modifier. */
  predicate isSuspend() { this.hasModifier("suspend") }

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

  /** Holds if this element has a `lateinit` modifier. */
  predicate isLateinit() { this.hasModifier("lateinit") }

  /** Holds if this element has a `reified` modifier. */
  predicate isReified() { this.hasModifier("reified") }

  /** Holds if this element has an `in` modifier. */
  predicate isIn() { this.hasModifier("in") }

  /** Holds if this element has an `out` modifier. */
  predicate isOut() { this.hasModifier("out") }
}
