import java
import DataFlow
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.spring.SpringWeb
import semmle.code.java.security.RequestForgery
private import semmle.code.java.dataflow.StringPrefixes

/** A sink for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSink extends DataFlow::Node { }

/** A sanitizer for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSanitizer extends DataFlow::Node { }

/** A barrier guard that protects against URL forward vulnerabilities. */
abstract class UnsafeUrlForwardBarrierGuard extends DataFlow::BarrierGuard { }

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

/**
 * A guard that considers safe a string being exactly compared to a trusted value.
 */
private class ExactStringPathMatchGuard extends UnsafeUrlForwardBarrierGuard instanceof MethodAccess {
  ExactStringPathMatchGuard() {
    super.getMethod().getDeclaringType() instanceof TypeString and
    super.getMethod().getName() = ["equals", "equalsIgnoreCase"]
  }

  override predicate checks(Expr e, boolean branch) {
    e = super.getQualifier() and
    branch = true
  }
}

private class AllowListGuard extends Guard instanceof MethodAccess {
  AllowListGuard() {
    (isStringPartialMatch(this) or isPathPartialMatch(this)) and
    not isDisallowedWord(super.getAnArgument())
  }

  Expr getCheckedExpr() { result = super.getQualifier() }
}

/**
 * A guard that considers a path safe because it is checked against an allowlist of partial trusted values.
 * This requires additional protection against path traversal, either another guard (`PathTraversalGuard`)
 * or a sanitizer (`PathNormalizeSanitizer`), to ensure any internal `..` components are removed from the path.
 */
private class AllowListBarrierGuard extends UnsafeUrlForwardBarrierGuard instanceof AllowListGuard {
  override predicate checks(Expr e, boolean branch) {
    e = super.getCheckedExpr() and
    branch = true and
    (
      // Either a path normalization sanitizer comes before the guard,
      exists(PathNormalizeSanitizer sanitizer | DataFlow::localExprFlow(sanitizer, e))
      or
      // or a check like `!path.contains("..")` comes before the guard
      exists(PathTraversalGuard previousGuard |
        DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
        previousGuard.controls(this.getBasicBlock().(ConditionBlock), false)
      )
    )
  }
}

/**
 * A guard that considers a path safe because it is checked for `..` components, having previously
 * been checked for a trusted prefix.
 */
private class DotDotCheckBarrierGuard extends UnsafeUrlForwardBarrierGuard instanceof PathTraversalGuard {
  override predicate checks(Expr e, boolean branch) {
    e = super.getCheckedExpr() and
    branch = false and
    // The same value has previously been checked against a list of allowed prefixes:
    exists(AllowListGuard previousGuard |
      DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
      previousGuard.controls(this.getBasicBlock().(ConditionBlock), true)
    )
  }
}

private class BlockListGuard extends Guard instanceof MethodAccess {
  BlockListGuard() {
    (isStringPartialMatch(this) or isPathPartialMatch(this)) and
    isDisallowedWord(super.getAnArgument())
  }

  Expr getCheckedExpr() { result = super.getQualifier() }
}

/**
 * A guard that considers a string safe because it is checked against a blocklist of known dangerous values.
 * This requires a prior check for URL encoding concealing a forbidden value, either a guard (`UrlEncodingGuard`)
 * or a sanitizer (`UrlDecodeSanitizer`).
 */
private class BlockListBarrierGuard extends UnsafeUrlForwardBarrierGuard instanceof BlockListGuard {
  override predicate checks(Expr e, boolean branch) {
    e = super.getCheckedExpr() and
    branch = false and
    (
      // Either `e` has been URL decoded:
      exists(UrlDecodeSanitizer sanitizer | DataFlow::localExprFlow(sanitizer, e))
      or
      // or `e` has previously been checked for URL encoding sequences:
      exists(UrlEncodingGuard previousGuard |
        DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
        previousGuard.controls(this.getBasicBlock(), false)
      )
    )
  }
}

/**
 * A guard that considers a string safe because it is checked for URL encoding sequences,
 * having previously been checked against a block-list of forbidden values.
 */
private class URLEncodingBarrierGuard extends UnsafeUrlForwardBarrierGuard instanceof UrlEncodingGuard {
  override predicate checks(Expr e, boolean branch) {
    e = super.getCheckedExpr() and
    branch = false and
    exists(BlockListGuard previousGuard |
      DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
      previousGuard.controls(this.getBasicBlock(), false)
    )
  }
}

/**
 * Holds if `ma` is a call to a method that checks a partial string match.
 */
private predicate isStringPartialMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() =
    ["contains", "startsWith", "matches", "regionMatches", "indexOf", "lastIndexOf"]
}

/**
 * Holds if `ma` is a call to a method of `java.nio.file.Path` that checks a partial path match.
 */
private predicate isPathPartialMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypePath and
  ma.getMethod().getName() = "startsWith"
}

private predicate isDisallowedWord(CompileTimeConstantExpr word) {
  word.getStringValue().matches(["%WEB-INF%", "%META-INF%", "%..%"])
}

/** A complementary guard that protects against path traversal, by looking for the literal `..`. */
private class PathTraversalGuard extends Guard instanceof MethodAccess {
  Expr checked;

  PathTraversalGuard() {
    super.getMethod().getDeclaringType() instanceof TypeString and
    super.getMethod().hasName(["contains", "indexOf"]) and
    super.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".."
  }

  Expr getCheckedExpr() { result = super.getQualifier() }
}

/** A complementary sanitizer that protects against path traversal using path normalization. */
private class PathNormalizeSanitizer extends MethodAccess {
  PathNormalizeSanitizer() {
    this.getMethod().getDeclaringType().hasQualifiedName("java.nio.file", "Path") and
    this.getMethod().hasName("normalize")
  }
}

/** A complementary guard that protects against double URL encoding, by looking for the literal `%`. */
private class UrlEncodingGuard extends Guard instanceof MethodAccess {
  UrlEncodingGuard() {
    super.getMethod().getDeclaringType() instanceof TypeString and
    super.getMethod().hasName(["contains", "indexOf"]) and
    super.getAnArgument().(CompileTimeConstantExpr).getStringValue() = "%"
  }

  Expr getCheckedExpr() { result = super.getQualifier() }
}

/** A complementary sanitizer that protects against double URL encoding using URL decoding. */
private class UrlDecodeSanitizer extends MethodAccess {
  UrlDecodeSanitizer() {
    this.getMethod().getDeclaringType().hasQualifiedName("java.net", "URLDecoder") and
    this.getMethod().hasName("decode")
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
