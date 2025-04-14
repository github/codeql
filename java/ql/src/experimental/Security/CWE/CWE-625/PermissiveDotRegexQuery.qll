/** Provides classes related to security-centered regular expression matching. */
deprecated module;

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
import experimental.semmle.code.java.security.SpringUrlRedirect
import semmle.code.java.controlflow.Guards
import semmle.code.java.security.UrlRedirect
import Regex

private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "permissive-dot-regex-query" }
}

/** A string that ends with `.*` not prefixed with `\`. */
private class PermissiveDotStr extends StringLiteral {
  PermissiveDotStr() {
    exists(string s, int i | this.getValue() = s |
      s.indexOf(".*") = i and
      not s.charAt(i - 1) = "\\" and
      s.length() = i + 2
    )
  }
}

/** The qualifier of a request dispatch method call. */
private class UrlDispatchSink extends UrlRedirectSink {
  UrlDispatchSink() {
    exists(MethodCall ma |
      ma.getMethod() instanceof RequestDispatchMethod and
      this.asExpr() = ma.getQualifier()
    )
  }
}

/** The `doFilter` method of `javax.servlet.FilterChain`. */
private class ServletFilterMethod extends Method {
  ServletFilterMethod() {
    this.getDeclaringType().getASupertype*().hasQualifiedName("javax.servlet", "FilterChain") and
    this.hasName("doFilter")
  }
}

/** The qualifier of a servlet filter method call. */
private class UrlFilterSink extends UrlRedirectSink {
  UrlFilterSink() {
    exists(MethodCall ma |
      ma.getMethod() instanceof ServletFilterMethod and
      this.asExpr() = ma.getQualifier()
    )
  }
}

/** A Spring framework annotation indicating that a URI is user-provided. */
private class SpringUriInputAnnotation extends Annotation {
  SpringUriInputAnnotation() {
    this.getType()
        .hasQualifiedName("org.springframework.web.bind.annotation",
          ["PathVariable", "RequestParam"])
  }
}

/** A user-provided URI parameter of a request mapping method. */
private class SpringUriInputParameterSource extends DataFlow::Node {
  SpringUriInputParameterSource() {
    this.asParameter() =
      any(SpringRequestMappingParameter srmp |
        srmp.getAnAnnotation() instanceof SpringUriInputAnnotation
      )
  }
}

/**
 * A data flow sink to construct regular expressions.
 */
private class CompileRegexSink extends DataFlow::ExprNode {
  CompileRegexSink() {
    exists(MethodCall ma, Method m | m = ma.getMethod() |
      (
        ma.getArgument(0) = this.asExpr() and
        (
          m instanceof StringMatchMethod // input.matches(regexPattern)
          or
          m instanceof PatternCompileMethod // p = Pattern.compile(regexPattern)
          or
          m instanceof PatternMatchMethod // p = Pattern.matches(regexPattern, input)
        )
      )
    )
  }
}

/**
 * A data flow configuration for regular expressions that include permissive dots.
 */
private module PermissiveDotRegexConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof PermissiveDotStr }

  predicate isSink(DataFlow::Node sink) { sink instanceof CompileRegexSink }

  predicate isBarrier(DataFlow::Node node) {
    exists(
      MethodCall ma, Field f // Pattern.compile(PATTERN, Pattern.DOTALL)
    |
      ma.getMethod() instanceof PatternCompileMethod and
      ma.getArgument(1) = f.getAnAccess() and
      f.hasName("DOTALL") and
      f.getDeclaringType() instanceof Pattern and
      node.asExpr() = ma.getArgument(0)
    )
  }
}

private module PermissiveDotRegexFlow = DataFlow::Global<PermissiveDotRegexConfig>;

/**
 * A taint-tracking configuration for untrusted user input used to match regular expressions
 * that include permissive dots.
 */
module MatchRegexConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    sourceNode(source, "uri-path") or // Servlet uri source
    source instanceof SpringUriInputParameterSource // Spring uri source
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof MatchRegexSink and
    exists(
      Guard guard, Expr se, Expr ce // used in a condition to control url redirect, which is a typical security enforcement
    |
      (
        sink.asExpr() = ce.(MethodCall).getQualifier() or
        sink.asExpr() = ce.(MethodCall).getAnArgument() or
        sink.asExpr() = ce
      ) and
      (
        DataFlow::localExprFlow(ce, guard.(MethodCall).getQualifier()) or
        DataFlow::localExprFlow(ce, guard.(MethodCall).getAnArgument())
      ) and
      (
        DataFlow::exprNode(se) instanceof UrlRedirectSink or
        DataFlow::exprNode(se) instanceof SpringUrlRedirectSink
      ) and
      guard.controls(se.getBasicBlock(), true)
    ) and
    exists(MethodCall ma | PermissiveDotRegexFlow::flowToExpr(ma.getArgument(0)) |
      // input.matches(regexPattern)
      ma.getMethod() instanceof StringMatchMethod and
      ma.getQualifier() = sink.asExpr()
      or
      // p = Pattern.compile(regexPattern); p.matcher(input)
      ma.getMethod() instanceof PatternCompileMethod and
      exists(MethodCall pma |
        pma.getMethod() instanceof PatternMatcherMethod and
        sink.asExpr() = pma.getArgument(0) and
        DataFlow::localExprFlow(ma, pma.getQualifier())
      )
      or
      // p = Pattern.matches(regexPattern, input)
      ma.getMethod() instanceof PatternMatchMethod and
      sink.asExpr() = ma.getArgument(1)
    )
  }
}

module MatchRegexFlow = TaintTracking::Global<MatchRegexConfig>;

/**
 * A data flow sink representing a string being matched against a regular expression.
 */
abstract class MatchRegexSink extends DataFlow::ExprNode { }

/**
 * A string being matched against a regular expression.
 */
private class StringMatchRegexSink extends MatchRegexSink {
  StringMatchRegexSink() {
    exists(MethodCall ma, Method m | m = ma.getMethod() |
      (
        m instanceof StringMatchMethod and
        ma.getQualifier() = this.asExpr()
      )
    )
  }
}

/**
 * A string being matched against a regular expression using a pattern.
 */
private class PatternMatchRegexSink extends MatchRegexSink {
  PatternMatchRegexSink() {
    exists(MethodCall ma, Method m | m = ma.getMethod() |
      (
        m instanceof PatternMatchMethod and
        ma.getArgument(1) = this.asExpr()
      )
    )
  }
}

/**
 * A string being used to create a pattern matcher.
 */
private class PatternMatcherRegexSink extends MatchRegexSink {
  PatternMatcherRegexSink() {
    exists(MethodCall ma, Method m | m = ma.getMethod() |
      (
        m instanceof PatternMatcherMethod and
        ma.getArgument(0) = this.asExpr()
      )
    )
  }
}
