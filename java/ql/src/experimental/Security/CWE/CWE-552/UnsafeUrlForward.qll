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
    this.getMethod().getDeclaringType() instanceof TypeString and
    this.getMethod().getName() = ["equals", "equalsIgnoreCase"]
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and
    branch = true
  }
}

/**
 * A guard that considers safe a string being matched against an allowlist of partial trusted values.
 * This requires additional protection against path traversal, either another guard (`PathTraversalGuard`)
 * or a sanitizer (`PathNormalizeSanitizer`).
 */
private class AllowListCheckGuard extends UnsafeUrlForwardBarrierGuard instanceof MethodAccess {
  AllowListCheckGuard() {
    (isStringPartialMatch(this) or isPathPartialMatch(this)) and
    not isDisallowedWord(this.getAnArgument())
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and
    branch = true and
    (
      // Either the path normalization sanitizer comes before the guard
      exists(PathNormalizeSanitizer sanitizer | DataFlow::localExprFlow(sanitizer, e))
      or
      // or the path traversal check comes before the guard
      exists(PathTraversalGuard guard |
        guard.checks(any(Expr checked | DataFlow::localExprFlow(checked, e))) or
        // or both checks are in the same condition
        // (for example, `path.startsWith(BASE_PATH) && !path.contains("..")`)
        guard.controls(this.getBasicBlock().(ConditionBlock), false) or
        this.controls(guard.getBasicBlock().(ConditionBlock), branch)
      )
    )
  }
}

/**
 * A guard that considers safe a string being matched against a blocklist of known dangerous values.
 * This requires additional protection against path traversal, either another guard (`UrlEncodingGuard`)
 * or a sanitizer (`UrlDecodeSanitizer`).
 */
private class BlockListCheckGuard extends UnsafeUrlForwardBarrierGuard instanceof MethodAccess {
  BlockListCheckGuard() {
    (isStringPartialMatch(this) or isPathPartialMatch(this)) and
    isDisallowedWord(this.getAnArgument())
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and
    branch = false and
    (
      // Either the URL decode sanitization comes before the guard
      exists(UrlDecodeSanitizer sanitizer | DataFlow::localExprFlow(sanitizer, e))
      or
      // or the URL encoding check comes before the guard
      exists(UrlEncodingGuard guard |
        guard.checks(any(Expr checked | DataFlow::localExprFlow(checked, e)))
        or
        // or both checks are in the same condition
        // (for example, `!path.contains("..") && !path.contains("%")`)
        guard.controls(this.getBasicBlock().(ConditionBlock), false)
        or
        this.controls(guard.getBasicBlock().(ConditionBlock), branch)
      )
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
    this.getMethod().getDeclaringType() instanceof TypeString and
    this.getMethod().hasName(["contains", "indexOf"]) and
    this.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".." and
    this.controls(checked.getBasicBlock(), false)
  }

  predicate checks(Expr e) { checked = e }
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
  Expr checked;

  UrlEncodingGuard() {
    this.getMethod().getDeclaringType() instanceof TypeString and
    this.getMethod().hasName(["contains", "indexOf"]) and
    this.getAnArgument().(CompileTimeConstantExpr).getStringValue() = "%" and
    this.controls(checked.getBasicBlock(), false)
  }

  predicate checks(Expr e) { checked = e }
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
