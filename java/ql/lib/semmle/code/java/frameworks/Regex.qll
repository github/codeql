/** Definitions related to `java.util.regex`. */
overlay[local?]
module;

import java
private import semmle.code.java.dataflow.DataFlow

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
 * The `compile` method of `java.util.regex.Pattern`.
 */
class PatternCompileMethod extends Method {
  PatternCompileMethod() {
    this.getDeclaringType() instanceof TypeRegexPattern and
    this.hasName("compile")
  }
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

/** A call to the `compile` method of `java.util.regex.Pattern`. */
class PatternCompileCall extends MethodCall {
  PatternCompileCall() { this.getMethod() instanceof PatternCompileMethod }
}

/** A call to the `matcher` method of `java.util.regex.Pattern`. */
class PatternMatcherCall extends MethodCall {
  PatternMatcherCall() { this.getMethod() instanceof PatternMatcherMethod }
}

/** A call to the `matches` method of `java.util.regex.Pattern`. */
class PatternMatchesCall extends MethodCall, RegexMatch::Range {
  PatternMatchesCall() { this.getMethod() instanceof PatternMatchesMethod }

  override Expr getRegex() { result = this.getArgument(0) }

  override Expr getString() { result = this.getArgument(1) }

  override string getName() { result = "Pattern.matches" }
}

/** A call to the `matches` method of `java.util.regex.Matcher`. */
class MatcherMatchesCall extends MethodCall, RegexMatch::Range {
  MatcherMatchesCall() { this.getMethod() instanceof MatcherMatchesMethod }

  /**
   * Gets the call to `java.util.regex.Pattern.matcher` that returned the
   * qualifier of this call. This is needed to determine the string being
   * matched.
   */
  PatternMatcherCall getPatternMatcherCall() {
    DataFlow::localExprFlow(result, this.getQualifier())
  }

  /**
   * Gets the call to `java.util.regex.Pattern.compile` that returned the
   * `Pattern` used by this matcher. This is needed to determine the regular
   * expression being used.
   */
  PatternCompileCall getPatternCompileCall() {
    DataFlow::localExprFlow(result, this.getPatternMatcherCall())
  }

  override Expr getRegex() { result = this.getPatternCompileCall().getArgument(0) }

  override Expr getString() { result = this.getPatternMatcherCall().getArgument(0) }

  override Expr getAdditionalSanitizedExpr() {
    // Special case for MatcherMatchesCall. Consider the following code:
    //
    // Matcher matcher = Pattern.compile(regexp).matcher(taintedInput);
    // if (matcher.matches()) {
    //     sink(matcher.group(1));
    // }
    //
    // Even though the string is `taintedInput`, we also want to sanitize
    // `matcher` as it can be used to get substrings of `taintedInput`.
    result = this.getQualifier()
  }

  override string getName() { result = "Matcher.matches" }
}
