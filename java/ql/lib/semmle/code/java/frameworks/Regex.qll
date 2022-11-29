/** Definitions related to `java.util.regex`. */

private import semmle.code.java.dataflow.ExternalFlow

/** The class `java.util.regex.Pattern`. */
class TypeRegexPattern extends Class {
  TypeRegexPattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
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
