/**
 * @name Unsafe url forward or dispatch from remote source
 * @description URL forward or dispatch based on unvalidated user-input
 *              may cause file information disclosure.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-url-forward-dispatch
 * @tags security
 *       external/cwe-552
 */

import java
import UnsafeUrlForward
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.controlflow.Guards
import DataFlow::PathGraph

/**
 * Holds if `ma` is a method call of matching with a path string, probably a whitelisted one.
 */
predicate isStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() = ["startsWith", "matches", "regionMatches"]
}

/**
 * Holds if `ma` is a method call of `java.nio.file.Path` which matches with another
 * path, probably a whitelisted one.
 */
predicate isFilePathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypePath and
  ma.getMethod().getName() = "startsWith"
}

/**
 * Holds if `ma` is a method call that checks an input doesn't match using the `!`
 * logical negation expression.
 */
predicate checkNoPathMatch(MethodAccess ma) {
  exists(LogNotExpr lne |
    (isStringPathMatch(ma) or isFilePathMatch(ma)) and
    lne.getExpr() = ma
  )
}

/**
 * Holds if `ma` is a method call to check special characters `..` used in path traversal.
 */
predicate isPathTraversalCheck(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().hasName(["contains", "indexOf"]) and
  ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".."
}

/**
 * Holds if `ma` is a method call to decode a url string or check url encoding.
 */
predicate isPathDecoding(MethodAccess ma) {
  // Search the special character `%` used in url encoding
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().hasName(["contains", "indexOf"]) and
  ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = "%"
  or
  // Call to `URLDecoder` assuming the implementation handles double encoding correctly
  ma.getMethod().getDeclaringType().hasQualifiedName("java.net", "URLDecoder") and
  ma.getMethod().hasName("decode")
}

private class PathMatchSanitizer extends DataFlow::Node {
  PathMatchSanitizer() {
    exists(MethodAccess ma |
      (
        isStringPathMatch(ma) and
        exists(MethodAccess ma2 |
          isPathTraversalCheck(ma2) and
          ma.getQualifier().(VarAccess).getVariable().getAnAccess() = ma2.getQualifier()
        )
        or
        isFilePathMatch(ma)
      ) and
      (
        not checkNoPathMatch(ma)
        or
        // non-match check needs decoding e.g. !path.startsWith("/WEB-INF/") won't detect /%57EB-INF/web.xml, which will be decoded and served by RequestDispatcher
        checkNoPathMatch(ma) and
        exists(MethodAccess ma2 |
          isPathDecoding(ma2) and
          ma.getQualifier().(VarAccess).getVariable().getAnAccess() = ma2.getQualifier()
        )
      ) and
      this.asExpr() = ma.getQualifier()
    )
  }
}

/**
 * Holds if `ma` is a method call to check string content, which means an input string is not
 * blindly trusted and helps to reduce FPs.
 */
predicate checkStringContent(MethodAccess ma, Expr expr) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod()
      .hasName([
          "charAt", "contains", "equals", "equalsIgnoreCase", "getBytes", "getChars", "indexOf",
          "lastIndexOf", "length", "matches", "regionMatches", "replace", "replaceAll",
          "replaceFirst", "substring"
        ]) and
  expr = ma.getQualifier()
  or
  (
    ma.getMethod().getDeclaringType() instanceof TypeStringBuffer or
    ma.getMethod().getDeclaringType() instanceof TypeStringBuilder
  ) and
  expr = ma.getAnArgument()
}

private class StringOperationSanitizer extends DataFlow::Node {
  StringOperationSanitizer() { exists(MethodAccess ma | checkStringContent(ma, this.asExpr())) }
}

/**
 * Holds if `expr` is an expression returned from null or empty string check.
 */
predicate isNullOrEmptyCheck(Expr expr) {
  exists(ConditionBlock cb, ReturnStmt rt |
    cb.controls(rt.getBasicBlock(), true) and
    (
      cb.getCondition().(EQExpr).getAnOperand() instanceof NullLiteral // if (path == null)
      or
      // if (path.equals(""))
      exists(MethodAccess ma |
        cb.getCondition() = ma and
        ma.getMethod().getDeclaringType() instanceof TypeString and
        ma.getMethod().hasName("equals") and
        ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = ""
      )
    ) and
    expr.getParent+() = rt
  )
}

private class NullOrEmptyCheckSanitizer extends DataFlow::Node {
  NullOrEmptyCheckSanitizer() { isNullOrEmptyCheck(this.asExpr()) }
}

class UnsafeUrlForwardFlowConfig extends TaintTracking::Configuration {
  UnsafeUrlForwardFlowConfig() { this = "UnsafeUrlForwardFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not exists(MethodAccess ma, Method m | ma.getMethod() = m |
      (
        m instanceof HttpServletRequestGetRequestURIMethod or
        m instanceof HttpServletRequestGetRequestURLMethod or
        m instanceof HttpServletRequestGetPathMethod
      ) and
      ma = source.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeUrlForwardSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof UnsafeUrlForwardSanitizer or
    node instanceof PathMatchSanitizer or
    node instanceof StringOperationSanitizer or
    node instanceof NullOrEmptyCheckSanitizer
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeUrlForwardFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL forward due to $@.",
  source.getNode(), "user-provided value"
