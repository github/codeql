/** Provides methods related to regular expression matching. */

import java

/**
 * The class `Pattern` for pattern match.
 */
class Pattern extends RefType {
  Pattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
}

/**
 * The method `compile` for `Pattern`.
 */
class PatternCompileMethod extends Method {
  PatternCompileMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("compile")
  }
}

/**
 * The method `matches` for `Pattern`.
 */
class PatternMatchMethod extends Method {
  PatternMatchMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matches")
  }
}

/**
 * The method `matcher` for `Pattern`.
 */
class PatternMatcherMethod extends Method {
  PatternMatcherMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matcher")
  }
}

/**
 * The method `matches` for `String`.
 */
class StringMatchMethod extends Method {
  StringMatchMethod() {
    this.getDeclaringType().getASupertype*() instanceof TypeString and
    this.hasName("matches")
  }
}
