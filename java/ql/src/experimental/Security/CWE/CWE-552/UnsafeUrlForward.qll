import java
import DataFlow
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.spring.SpringWeb
import semmle.code.java.security.RequestForgery
private import semmle.code.java.dataflow.StringPrefixes

/** A sanitizer for unsafe url forward vulnerabilities. */
abstract class UnsafeUrlForwardSanitizer extends DataFlow::Node { }

private class PrimitiveSanitizer extends UnsafeUrlForwardSanitizer {
  PrimitiveSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}

private class SanitizingPrefix extends InterestingPrefix {
  SanitizingPrefix() {
    not this.getStringValue().matches("/WEB-INF/%") and
    not this.getStringValue() = "forward:"
  }

  override int getOffset() { result = 0 }
}

private class FollowsSanitizingPrefix extends UnsafeUrlForwardSanitizer {
  FollowsSanitizingPrefix() { this.asExpr() = any(SanitizingPrefix fp).getAnAppendedExpression() }
}

/** A barrier guard that protects against URL forward vulnerabilities. */
abstract class UnsafeUrlForwardBarrierGuard extends DataFlow::BarrierGuard { }

/**
 * Holds if `ma` is a call to a method that checks exact match of string.
 */
private predicate isExactStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() = ["equals", "equalsIgnoreCase"]
}

/**
 * Holds if `ma` is a call to a method that checks a path string.
 */
private predicate isStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() =
    ["contains", "startsWith", "matches", "regionMatches", "indexOf", "lastIndexOf"]
}

/**
 * Holds if `ma` is a call to a method of `java.nio.file.Path` that checks a path.
 */
private predicate isFilePathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypePath and
  ma.getMethod().getName() = "startsWith"
}

/**
 * Holds if `ma` protects against path traversal, by either:
 * * looking for the literal `..`
 * * performing path normalization
 */
private predicate isPathTraversalCheck(MethodAccess ma, Expr checked) {
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
private predicate isURLEncodingCheck(MethodAccess ma, Expr checked) {
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
private class PathNormalizeMethod extends Method {
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
private class PathMatchGuard extends UnsafeUrlForwardBarrierGuard {
  PathMatchGuard() {
    isExactStringPathMatch(this) or isAllowListCheck(this) or isDisallowListCheck(this)
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

abstract class UnsafeUrlForwardSink extends DataFlow::Node { }

/** An argument to `getRequestDispatcher`. */
private class RequestDispatcherSink extends UnsafeUrlForwardSink {
  RequestDispatcherSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof GetRequestDispatcherMethod and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/** An argument to `new ModelAndView` or `ModelAndView.setViewName`. */
private class SpringModelAndViewSink extends UnsafeUrlForwardSink {
  SpringModelAndViewSink() {
    exists(ClassInstanceExpr cie |
      cie.getConstructedType() instanceof ModelAndView and
      cie.getArgument(0) = this.asExpr()
    )
    or
    exists(SpringModelAndViewSetViewNameCall smavsvnc | smavsvnc.getArgument(0) = this.asExpr())
  }
}

private class ForwardPrefix extends InterestingPrefix {
  ForwardPrefix() { this.getStringValue() = "forward:" }

  override int getOffset() { result = 0 }
}

/**
 * An expression appended (perhaps indirectly) to `"forward:"`, and which
 * is reachable from a Spring entry point.
 */
private class SpringUrlForwardSink extends UnsafeUrlForwardSink {
  SpringUrlForwardSink() {
    any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable()) and
    this.asExpr() = any(ForwardPrefix fp).getAnAppendedExpression()
  }
}

/** Source model of remote flow source from `getServletPath`. */
private class ServletGetPathSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.servlet.http;HttpServletRequest;true;getServletPath;;;ReturnValue;remote",
        "jakarta.servlet.http;HttpServletRequest;true;getServletPath;;;ReturnValue;remote"
      ]
  }
}

/** Taint model related to `java.nio.file.Path`. */
private class FilePathFlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.nio.file;Paths;true;get;;;Argument[0..1];ReturnValue;taint",
        "java.nio.file;Path;true;resolve;;;Argument[-1..0];ReturnValue;taint",
        "java.nio.file;Path;true;normalize;;;Argument[-1];ReturnValue;taint",
        "java.nio.file;Path;true;toString;;;Argument[-1];ReturnValue;taint"
      ]
  }
}
