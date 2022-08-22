/** Provides classes related to security-centered regular expression matching. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
import experimental.semmle.code.java.security.SpringUrlRedirect
import semmle.code.java.controlflow.Guards
import semmle.code.java.security.UrlRedirect
import Regex

/** A string that ends with `.*` not prefixed with `\`. */
class PermissiveDotStr extends StringLiteral {
  PermissiveDotStr() {
    exists(string s, int i | this.getValue() = s |
      s.indexOf(".*") = i and
      not s.charAt(i - 1) = "\\" and
      s.length() = i + 2
    )
  }
}

/** Source model of remote flow source with servlets. */
private class GetServletUriSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.servlet.http;HttpServletRequest;false;getPathInfo;();;ReturnValue;uri-path;manual",
        "javax.servlet.http;HttpServletRequest;false;getPathTranslated;();;ReturnValue;uri-path;manual",
        "javax.servlet.http;HttpServletRequest;false;getRequestURI;();;ReturnValue;uri-path;manual",
        "javax.servlet.http;HttpServletRequest;false;getRequestURL;();;ReturnValue;uri-path;manual",
        "javax.servlet.http;HttpServletRequest;false;getServletPath;();;ReturnValue;uri-path;manual"
      ]
  }
}

/** Sink of servlet dispatcher. */
private class UrlDispatchSink extends UrlRedirectSink {
  UrlDispatchSink() {
    exists(MethodAccess ma |
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

/** Sink of servlet filter. */
private class UrlFilterSink extends UrlRedirectSink {
  UrlFilterSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof ServletFilterMethod and
      this.asExpr() = ma.getQualifier()
    )
  }
}

/** A Spring framework annotation indicating remote uri user input. */
class SpringUriInputAnnotation extends Annotation {
  SpringUriInputAnnotation() {
    this.getType()
        .hasQualifiedName("org.springframework.web.bind.annotation",
          ["PathVariable", "RequestParam"])
  }
}

class SpringUriInputParameterSource extends DataFlow::Node {
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
class CompileRegexSink extends DataFlow::ExprNode {
  CompileRegexSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
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
 * A flow configuration for permissive dot regex.
 */
class PermissiveDotRegexConfig extends DataFlow::Configuration {
  PermissiveDotRegexConfig() { this = "PermissiveDotRegex::PermissiveDotRegexConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof PermissiveDotStr }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CompileRegexSink }

  override predicate isBarrier(DataFlow::Node node) {
    exists(
      MethodAccess ma, Field f // Pattern.compile(PATTERN, Pattern.DOTALL)
    |
      ma.getMethod() instanceof PatternCompileMethod and
      ma.getArgument(1) = f.getAnAccess() and
      f.hasName("DOTALL") and
      f.getDeclaringType() instanceof Pattern and
      node.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * A taint-tracking configuration for untrusted user input used to match regular expressions.
 */
class MatchRegexConfiguration extends TaintTracking::Configuration {
  MatchRegexConfiguration() { this = "PermissiveDotRegex::MatchRegexConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    sourceNode(source, "uri-path") or // Servlet uri source
    source instanceof SpringUriInputParameterSource // Spring uri source
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof MatchRegexSink and
    exists(
      Guard guard, Expr se, Expr ce // used in a condition to control url redirect, which is a typical security enforcement
    |
      (
        sink.asExpr() = ce.(MethodAccess).getQualifier() or
        sink.asExpr() = ce.(MethodAccess).getAnArgument() or
        sink.asExpr() = ce
      ) and
      (
        DataFlow::localExprFlow(ce, guard.(MethodAccess).getQualifier()) or
        DataFlow::localExprFlow(ce, guard.(MethodAccess).getAnArgument())
      ) and
      (
        DataFlow::exprNode(se) instanceof UrlRedirectSink or
        DataFlow::exprNode(se) instanceof SpringUrlRedirectSink
      ) and
      guard.controls(se.getBasicBlock(), true)
    )
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
