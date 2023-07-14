/** Provides methods related to regular expression matching and String manipulation. */

import java

/**
 * The class `java.util.regex.Pattern`.
 */
class Pattern extends RefType {
  Pattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
}

/**
 * The method `compile` of `java.util.regex.Pattern`, or one of its subtypes.
 */
class PatternCompileMethod extends Method {
  PatternCompileMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("compile")
  }
}

/**
 * The method `matches` of `java.util.regex.Pattern`, or one of its subtypes.
 */
class PatternMatchMethod extends Method {
  PatternMatchMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matches")
  }
}

/**
 * The method `matcher` of `java.util.regex.Pattern`, or one of its subtypes.
 */
class PatternMatcherMethod extends Method {
  PatternMatcherMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matcher")
  }
}

/**
 * The methods like `matches` of `java.lang.String`, or one of its subtypes.
 */
class StringMethod extends Method {
  StringMethod() { this.getDeclaringType().getASupertype*() instanceof TypeString }
}
