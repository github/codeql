/** Provides classes and predicates related to regex injection in Java. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.Regex
private import semmle.code.java.frameworks.apache.Lang

/** A data flow sink for untrusted user input used to construct regular expressions. */
abstract class RegexInjectionSink extends DataFlow::ExprNode { }

/** A sanitizer for untrusted user input used to construct regular expressions. */
abstract class RegexInjectionSanitizer extends DataFlow::ExprNode { }

/** A method call that takes a regular expression as an argument. */
private class DefaultRegexInjectionSink extends RegexInjectionSink {
  DefaultRegexInjectionSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      ma.getArgument(0) = this.asExpr() and
      (
        m instanceof StringRegexMethod or
        m instanceof PatternRegexMethod
      )
      or
      ma.getArgument(1) = this.asExpr() and
      m instanceof ApacheRegExUtilsMethod
    )
  }
}

/** A call to a function whose name suggests that it escapes regular expression meta-characters. */
private class RegexSanitizationCall extends RegexInjectionSanitizer {
  RegexSanitizationCall() {
    exists(string calleeName, string sanitize, string regexp |
      calleeName = this.asExpr().(Call).getCallee().getName() and
      sanitize = "(?:escape|saniti[sz]e)" and
      regexp = "regexp?"
    |
      calleeName
          .regexpMatch("(?i)(" + sanitize + ".*" + regexp + ".*)" + "|(" + regexp + ".*" + sanitize +
              ".*)")
    )
  }
}

/**
 * A call to the `Pattern.quote` method, which gives meta-characters or escape sequences
 * no special meaning.
 */
private class PatternQuoteCall extends RegexInjectionSanitizer {
  PatternQuoteCall() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      ma.getArgument(0) = this.asExpr() and
      m instanceof PatternQuoteMethod
    )
  }
}

/**
 * Use of the `Pattern.LITERAL` flag with `Pattern.compile`, which gives meta-characters
 * or escape sequences no special meaning.
 */
private class PatternLiteralFlag extends RegexInjectionSanitizer {
  PatternLiteralFlag() {
    exists(MethodAccess ma, Method m, Field field | m = ma.getMethod() |
      ma.getArgument(0) = this.asExpr() and
      m instanceof PatternRegexMethod and
      m.hasName("compile") and
      field instanceof PatternLiteral and
      ma.getArgument(1) = field.getAnAccess()
    )
  }
}

/**
 * A method of the class `java.lang.String` that takes a regular expression
 * as a parameter.
 */
private class StringRegexMethod extends Method {
  StringRegexMethod() {
    this.getDeclaringType() instanceof TypeString and
    this.hasName(["matches", "split", "replaceFirst", "replaceAll"])
  }
}

/**
 * A method of the class `java.util.regex.Pattern` that takes a regular
 * expression as a parameter.
 */
private class PatternRegexMethod extends Method {
  PatternRegexMethod() {
    this.getDeclaringType() instanceof TypeRegexPattern and
    this.hasName(["compile", "matches"])
  }
}

/**
 * A methods of the class `org.apache.commons.lang3.RegExUtils` that takes
 * a regular expression of type `String` as a parameter.
 */
private class ApacheRegExUtilsMethod extends Method {
  ApacheRegExUtilsMethod() {
    this.getDeclaringType() instanceof TypeApacheRegExUtils and
    // only handles String param here because the other param option, Pattern, is already handled by `java.util.regex.Pattern`
    this.getParameterType(1) instanceof TypeString and
    this.hasName([
        "removeAll", "removeFirst", "removePattern", "replaceAll", "replaceFirst", "replacePattern"
      ])
  }
}
