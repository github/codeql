/** Provides classes and predicates related to regex injection in Java. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.frameworks.Regex

/** A data flow sink for untrusted user input used to construct regular expressions. */
abstract class RegexInjectionSink extends DataFlow::ExprNode { }

/** A sanitizer for untrusted user input used to construct regular expressions. */
abstract class RegexInjectionSanitizer extends DataFlow::ExprNode { }

/** A method call that takes a regular expression as an argument. */
private class DefaultRegexInjectionSink extends RegexInjectionSink {
  DefaultRegexInjectionSink() {
    // we only select sinks where there is direct regex creation, not regex uses
    sinkNode(this, ["regex-use[]", "regex-use[f1]", "regex-use[f-1]", "regex-use[-1]", "regex-use"])
  }
}

/**
 * A call to the `Pattern.quote` method, which gives metacharacters or escape sequences
 * no special meaning.
 */
private class PatternQuoteCall extends RegexInjectionSanitizer {
  PatternQuoteCall() {
    exists(MethodCall ma, Method m | m = ma.getMethod() |
      ma.getArgument(0) = this.asExpr() and
      m instanceof PatternQuoteMethod
    )
  }
}

/**
 * Use of the `Pattern.LITERAL` flag with `Pattern.compile`, which gives metacharacters
 * or escape sequences no special meaning.
 */
private class PatternLiteralFlag extends RegexInjectionSanitizer {
  PatternLiteralFlag() {
    exists(MethodCall ma, Method m, PatternLiteralField field | m = ma.getMethod() |
      ma.getArgument(0) = this.asExpr() and
      m.getDeclaringType() instanceof TypeRegexPattern and
      m.hasName("compile") and
      ma.getArgument(1) = field.getAnAccess()
    )
  }
}
