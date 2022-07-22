/**
 * @name URL matched by permissive `.` in the regular expression
 * @description URL validated with permissive `.` in regex  are possibly vulnerable
 *              to an authorization bypass.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/permissive-dot-regex
 * @tags security
 *       external/cwe-625
 *       external/cwe-863
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.UrlRedirect
import DataFlow::PathGraph
import Regex

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

/**
 * `.` without a `\` prefix, which is likely not a character literal in regex
 */
class PermissiveDotStr extends StringLiteral {
  PermissiveDotStr() {
    // Find `.` in a string that is not prefixed with `\` and ends with `.*` (no suffix like file extension)
    exists(string s, int i | this.getValue() = s |
      s.indexOf(".*") = i and
      not s.charAt(i - 1) = "\\" and
      s.length() = i + 2
    )
  }
}

/**
 * Permissive `.` in a regular expression.
 */
class PermissiveDotEx extends Expr {
  PermissiveDotEx() { this instanceof PermissiveDotStr }
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

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof PermissiveDotEx }

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

  override predicate isSource(DataFlow::Node source) { sourceNode(source, "uri-path") }

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
      DataFlow::exprNode(se) instanceof UrlRedirectSink and
      guard.controls(se.getBasicBlock(), true)
    )
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, MatchRegexConfiguration conf,
  DataFlow::PathNode source2, DataFlow::PathNode sink2, PermissiveDotRegexConfig conf2
where
  conf.hasFlowPath(source, sink) and
  conf2.hasFlowPath(source2, sink2) and
  exists(MethodAccess ma | ma.getArgument(0) = sink2.getNode().asExpr() |
    // input.matches(regexPattern)
    ma.getMethod() instanceof StringMatchMethod and
    ma.getQualifier() = sink.getNode().asExpr()
    or
    // p = Pattern.compile(regexPattern); p.matcher(input)
    ma.getMethod() instanceof PatternCompileMethod and
    exists(MethodAccess pma |
      pma.getMethod() instanceof PatternMatcherMethod and
      sink.getNode().asExpr() = pma.getArgument(0) and
      DataFlow::localExprFlow(ma, pma.getQualifier())
    )
    or
    // p = Pattern.matches(regexPattern, input)
    ma.getMethod() instanceof PatternMatchMethod and
    sink.getNode().asExpr() = ma.getArgument(1)
  )
select sink.getNode(), source, sink, "Potentially authentication bypass due to $@.",
  source.getNode(), "user-provided value"
