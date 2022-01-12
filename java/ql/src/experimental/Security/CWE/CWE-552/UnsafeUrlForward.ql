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
 * Holds if `ma` is a call to a method that checks exact match of string, probably a whitelisted one.
 */
predicate isExactStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() = ["equals", "equalsIgnoreCase"]
}

/**
 * Holds if `ma` is a call to a method that checks a path string, probably a whitelisted one.
 */
predicate isStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() =
    ["contains", "startsWith", "matches", "regionMatches", "indexOf", "lastIndexOf"]
}

/**
 * Holds if `ma` is a call to a method of `java.nio.file.Path` that checks a path, probably
 * a whitelisted one.
 */
predicate isFilePathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypePath and
  ma.getMethod().getName() = "startsWith"
}

/**
 * Holds if `ma` is a call to a method that checks an input doesn't match using the `!`
 * logical negation expression.
 */
predicate checkNoPathMatch(MethodAccess ma) {
  exists(LogNotExpr lne |
    (isStringPathMatch(ma) or isFilePathMatch(ma)) and
    lne.getExpr() = ma
  )
}

/**
 * Holds if `ma` is a call to a method that checks special characters `..` used in path traversal.
 */
predicate isPathTraversalCheck(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().hasName(["contains", "indexOf"]) and
  ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".."
}

/**
 * Holds if `ma` is a call to a method that decodes a URL string or check URL encoding.
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

/** The Java method `normalize` of `java.nio.file.Path`. */
class PathNormalizeMethod extends Method {
  PathNormalizeMethod() {
    this.getDeclaringType().hasQualifiedName("java.nio.file", "Path") and
    this.hasName("normalize")
  }
}

/**
 * Sanitizer to check the following scenarios in a web application:
 *  1. Exact string match
 *  2. String startsWith or match check with path traversal validation
 *  3. String not startsWith or not match check with decoding processing
 *  4. java.nio.file.Path startsWith check having path normalization
 */
private class PathMatchSanitizer extends DataFlow::BarrierGuard {
  PathMatchSanitizer() {
    isExactStringPathMatch(this)
    or
    isStringPathMatch(this) and
    not checkNoPathMatch(this) and
    exists(MethodAccess tma |
      isPathTraversalCheck(tma) and
      DataFlow::localExprFlow(this.(MethodAccess).getQualifier(), tma.getQualifier())
    )
    or
    checkNoPathMatch(this) and
    exists(MethodAccess dma |
      isPathDecoding(dma) and
      DataFlow::localExprFlow(dma, this.(MethodAccess).getQualifier())
    )
    or
    isFilePathMatch(this) and
    exists(MethodAccess pma |
      pma.getMethod() instanceof PathNormalizeMethod and
      DataFlow::localExprFlow(pma, this.(MethodAccess).getQualifier())
    )
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and
    (
      branch = true and not checkNoPathMatch(this)
      or
      branch = false and checkNoPathMatch(this)
    )
  }
}

/**
 * Holds if `ma` is a call to a method that checks string content, which means an input string is not
 * blindly trusted and helps to reduce FPs.
 */
predicate checkStringContent(MethodAccess ma, Expr expr) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod()
      .hasName([
          "charAt", "getBytes", "getChars", "length", "replace", "replaceAll", "replaceFirst",
          "substring"
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
    node instanceof StringOperationSanitizer or
    node instanceof NullOrEmptyCheckSanitizer
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof PathMatchSanitizer
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeUrlForwardFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL forward due to $@.",
  source.getNode(), "user-provided value"
