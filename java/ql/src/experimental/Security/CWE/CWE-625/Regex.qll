/** Provides methods related to regular expression matching. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking2

/**
 * The  class `Pattern` for pattern match.
 */
class Pattern extends RefType {
  Pattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
}

/**
 * The  method `compile` for `Pattern`.
 */
class PatternCompileMethod extends Method {
  PatternCompileMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("compile")
  }
}

/**
 * The  method `matches` for `Pattern`.
 */
class PatternMatchMethod extends Method {
  PatternMatchMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matches")
  }
}

/**
 * The  method `matcher` for `Pattern`.
 */
class PatternMatcherMethod extends Method {
  PatternMatcherMethod() {
    this.getDeclaringType().getASupertype*() instanceof Pattern and
    this.hasName("matcher")
  }
}

/**
 * The  method `matches` for `String`.
 */
class StringMatchMethod extends Method {
  StringMatchMethod() {
    this.getDeclaringType().getASupertype*() instanceof TypeString and
    this.hasName("matches")
  }
}

abstract class MatchRegexSink extends DataFlow::ExprNode { }

/**
 * A data flow sink to string match regular expressions.
 */
class StringMatchRegexSink extends MatchRegexSink {
  StringMatchRegexSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m instanceof StringMatchMethod and
        ma.getQualifier() = this.asExpr()
      )
    )
  }
}

/**
 * A data flow sink to `pattern.matches` regular expressions.
 */
class PatternMatchRegexSink extends MatchRegexSink {
  PatternMatchRegexSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m instanceof PatternMatchMethod and
        ma.getArgument(1) = this.asExpr()
      )
    )
  }
}

/**
 * A data flow sink to `pattern.matcher` match regular expressions.
 */
class PatternMatcherRegexSink extends MatchRegexSink {
  PatternMatcherRegexSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m instanceof PatternMatcherMethod and
        ma.getArgument(0) = this.asExpr()
      )
    )
  }
}
