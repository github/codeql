/** Provides classes and predicates related to Javadoc conventions. */

import java

/** Holds if the given `Javadoc` contains a minimum of a few characters of text. */
private predicate acceptableDocText(Javadoc j) {
  // Require minimum combined length of all non-tag elements.
  sum(JavadocElement e, int toSum |
    e = j.getAChild() and
    not e = j.getATag(_) and
    toSum = e.toString().length()
  |
    toSum
  ) >= 5
}

/** Holds if the given `JavadocTag` contains a minimum of a few characters of text. */
private predicate acceptableTag(JavadocTag t) {
  sum(JavadocElement e, int toSum |
    e = t.getAChild() and
    toSum = e.toString().length()
  |
    toSum
  ) >= 5
}

/** A public `RefType`. */
class DocuRefType extends RefType {
  DocuRefType() {
    this.fromSource() and
    this.isPublic()
  }

  /** Holds if the Javadoc for this type contains a minimum of a few characters of text. */
  predicate hasAcceptableDocText() { acceptableDocText(this.getDoc().getJavadoc()) }
}

/** A public (non-getter, non-setter) `Callable` that does not override another method. */
class DocuCallable extends Callable {
  DocuCallable() {
    this.fromSource() and
    this.isPublic() and
    // Ignore overriding methods (only require Javadoc on the root method).
    not exists(Method root | this.(Method).overrides(root)) and
    // Ignore getters and setters.
    not this instanceof SetterMethod and
    not this instanceof GetterMethod and
    // Ignore synthetic/implicit constructors.
    not this.getLocation() = this.getDeclaringType().getLocation()
  }

  /** Holds if the Javadoc for this callable contains a minimum of a few characters of text. */
  predicate hasAcceptableDocText() { acceptableDocText(this.getDoc().getJavadoc()) }

  /** Gets a string to identify whether this callable is a "method" or a "constructor". */
  string toMethodOrConstructorString() {
    this instanceof Method and result = "method"
    or
    this instanceof Constructor and result = "constructor"
  }
}

/** A `Parameter` belonging to a `DocuCallable` that has some `Javadoc`. */
class DocuParam extends Parameter {
  DocuParam() {
    this.fromSource() and
    this.getCallable() instanceof DocuCallable and
    // Only consider callables with Javadoc.
    exists(this.getCallable().getDoc().getJavadoc())
  }

  /** Holds if this parameter has a non-trivial `@param` tag. */
  predicate hasAcceptableParamTag() {
    exists(ParamTag t |
      t = this.getCallable().getDoc().getJavadoc().getATag("@param") and
      t.getParamName() = this.getName() and
      acceptableTag(t)
    )
  }
}

/** A `DocuCallable` that is a method with `Javadoc` whose return type is not `void`. */
class DocuReturn extends DocuCallable {
  DocuReturn() {
    this instanceof Method and
    not this.getReturnType().hasName("void") and
    // Only consider methods with Javadoc.
    exists(this.getDoc().getJavadoc())
  }

  /** Holds if this callable's `Javadoc` has a non-trivial `@return` tag. */
  predicate hasAcceptableReturnTag() {
    acceptableTag(this.getDoc().getJavadoc().getATag("@return"))
  }
}

/** A `DocuCallable` that has `Javadoc` and throws at least one exception. */
class DocuThrows extends DocuCallable {
  DocuThrows() {
    this.fromSource() and
    // Only consider callables that throw at least one exception.
    exists(this.getAnException()) and
    // Only consider callables with Javadoc.
    exists(this.getDoc().getJavadoc())
  }

  /**
   * Holds if this callable has a non-trivial Javadoc `@throws` or `@exception` tag
   * documenting the given `Exception e`.
   */
  predicate hasAcceptableThrowsTag(Exception e) {
    exists(Javadoc j |
      j = this.getDoc().getJavadoc() and
      exists(JavadocTag t |
        (t = j.getATag("@throws") or t = j.getATag("@exception")) and
        t.getChild(0).toString() = e.getName() and
        acceptableTag(t)
      )
    )
  }
}
