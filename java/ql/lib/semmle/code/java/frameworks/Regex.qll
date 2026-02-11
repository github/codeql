/** Definitions related to `java.util.regex`. */
overlay[local?]
module;

import java

/** The class `java.util.regex.Matcher`. */
class TypeRegexMatcher extends Class {
  TypeRegexMatcher() { this.hasQualifiedName("java.util.regex", "Matcher") }
}

/**
 * The `matches` method of `java.util.regex.Matcher`.
 */
class MatcherMatchesMethod extends Method {
  MatcherMatchesMethod() {
    this.getDeclaringType() instanceof TypeRegexMatcher and
    this.hasName("matches")
  }
}

/** The class `java.util.regex.Pattern`. */
class TypeRegexPattern extends Class {
  TypeRegexPattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
}

/**
 * The `matches` method of `java.util.regex.Pattern`.
 */
class PatternMatchesMethod extends Method {
  PatternMatchesMethod() {
    this.getDeclaringType() instanceof TypeRegexPattern and
    this.hasName("matches")
  }
}

/**
 * The `matcher` method of `java.util.regex.Pattern`.
 */
class PatternMatcherMethod extends Method {
  PatternMatcherMethod() {
    this.getDeclaringType() instanceof TypeRegexPattern and
    this.hasName("matcher")
  }
}

/** The `quote` method of the `java.util.regex.Pattern` class. */
class PatternQuoteMethod extends Method {
  PatternQuoteMethod() {
    this.getDeclaringType() instanceof TypeRegexPattern and
    this.hasName("quote")
  }
}

/** The `LITERAL` field of the `java.util.regex.Pattern` class. */
class PatternLiteralField extends Field {
  PatternLiteralField() {
    this.getDeclaringType() instanceof TypeRegexPattern and
    this.hasName("LITERAL")
  }
}
