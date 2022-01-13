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
import semmle.code.java.dataflow.NullGuards
import DataFlow::PathGraph

/**
 * Holds if `ma` is a call to a method that checks exact match of string.
 */
predicate isExactStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() = ["equals", "equalsIgnoreCase"]
}

/**
 * Holds if `ma` is a call to a method that checks a path string.
 */
predicate isStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() =
    ["contains", "startsWith", "matches", "regionMatches", "indexOf", "lastIndexOf"]
}

/**
 * Holds if `ma` is a call to a method of `java.nio.file.Path` that checks a path.
 */
predicate isFilePathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypePath and
  ma.getMethod().getName() = "startsWith"
}

/**
 * Holds if `ma` protects against path traversal, by either:
 * * looking for the literal `..`
 * * performing path normalization
 */
predicate isPathTraversalCheck(MethodAccess ma, Expr checked) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().hasName(["contains", "indexOf"]) and
  ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".." and
  ma.(Guard).controls(checked.getBasicBlock(), false)
  or
  ma.getMethod() instanceof PathNormalizeMethod and
  checked = ma
}

/**
 * Holds if `ma` protects against double URL encoding, by either:
 * * looking for the literal `%`
 * * performing URL decoding
 */
predicate isURLEncodingCheck(MethodAccess ma, Expr checked) {
  // Search the special character `%` used in url encoding
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().hasName(["contains", "indexOf"]) and
  ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = "%" and
  ma.(Guard).controls(checked.getBasicBlock(), false)
  or
  // Call to `URLDecoder` assuming the implementation handles double encoding correctly
  ma.getMethod().getDeclaringType().hasQualifiedName("java.net", "URLDecoder") and
  ma.getMethod().hasName("decode") and
  checked = ma
}

/** The Java method `normalize` of `java.nio.file.Path`. */
class PathNormalizeMethod extends Method {
  PathNormalizeMethod() {
    this.getDeclaringType().hasQualifiedName("java.nio.file", "Path") and
    this.hasName("normalize")
  }
}

private predicate isDisallowedWord(CompileTimeConstantExpr word) {
  word.getStringValue().matches(["%WEB-INF%", "%META-INF%", "%..%"])
}

private predicate isAllowListCheck(MethodAccess ma) {
  (isStringPathMatch(ma) or isFilePathMatch(ma)) and
  not isDisallowedWord(ma.getAnArgument())
}

private predicate isDisallowListCheck(MethodAccess ma) {
  (isStringPathMatch(ma) or isFilePathMatch(ma)) and
  isDisallowedWord(ma.getAnArgument())
}

/**
 * A guard that checks a path with the following methods:
 *  1. Exact string match
 *  2. Path matches allowed values (needs to protect against path traversal)
 *  3. Path matches disallowed values (needs to protect against URL encoding)
 */
private class PathMatchGuard extends DataFlow::BarrierGuard {
  PathMatchGuard() {
    isExactStringPathMatch(this) or isStringPathMatch(this) or isFilePathMatch(this)
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and
    (
      isExactStringPathMatch(this) and
      branch = true
      or
      isAllowListCheck(this) and
      exists(MethodAccess ma, Expr checked | isPathTraversalCheck(ma, checked) |
        DataFlow::localExprFlow(checked, e)
        or
        ma.getParent*().(BinaryExpr) = this.(MethodAccess).getParent*()
      ) and
      branch = true
      or
      isDisallowListCheck(this) and
      exists(MethodAccess ma, Expr checked | isURLEncodingCheck(ma, checked) |
        DataFlow::localExprFlow(checked, e)
        or
        ma.getParent*().(BinaryExpr) = this.(MethodAccess).getParent*()
      ) and
      branch = false
    )
  }
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

  override predicate isSanitizer(DataFlow::Node node) { node instanceof UnsafeUrlForwardSanitizer }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof PathMatchGuard
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeUrlForwardFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL forward due to $@.",
  source.getNode(), "user-provided value"
