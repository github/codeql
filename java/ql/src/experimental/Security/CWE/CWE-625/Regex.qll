/** Provides methods related to regular expression matching. */
deprecated module;

import java

/**
 * The class `java.util.regex.Pattern`.
 */
class Pattern extends RefType {
  Pattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
}

/**
 * The method `compile` of `java.util.regex.Pattern`.
 */
class PatternCompileMethod extends Method {
  PatternCompileMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("compile")
  }
}

/**
 * The method `matches` of `java.util.regex.Pattern`.
 */
class PatternMatchMethod extends Method {
  PatternMatchMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matches")
  }
}

/**
 * The method `matcher` of `java.util.regex.Pattern`.
 */
class PatternMatcherMethod extends Method {
  PatternMatcherMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matcher")
  }
}

/**
 * The method `matches` of `java.lang.String`.
 */
class StringMatchMethod extends Method {
  StringMatchMethod() {
    this.getDeclaringType().getASupertype*() instanceof TypeString and
    this.hasName("matches")
  }
}
