import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow

/**
 * DEPRECATED: Use `PathTraversalSanitizer` instead.
 *
 * A barrier guard that protects against path traversal vulnerabilities.
 */
abstract deprecated class PathTraversalBarrierGuard extends DataFlow::BarrierGuard { }

/** A sanitizer that protects against path traversal vulnerabilities. */
abstract class PathTraversalSanitizer extends DataFlow::Node { }

/**
 * Holds if `g` is guard that compares a string to a trusted value.
 */
private predicate exactStringPathMatchGuard(Guard g, Expr e, boolean branch) {
  exists(MethodAccess ma |
    ma = g and
    ma.getMethod().getDeclaringType() instanceof TypeString and
    ma.getMethod().getName() = ["equals", "equalsIgnoreCase"] and
    e = ma.getQualifier() and
    branch = true
  )
}

private class ExactStringPathMatchSanitizer extends PathTraversalSanitizer {
  ExactStringPathMatchSanitizer() {
    this = DataFlow::BarrierGuard<exactStringPathMatchGuard/3>::getABarrierNode()
  }
}

/**
 * Given input `e` = `v.method1(...).method2(...)...`, returns `v` where `v` is a `VarAccess`.
 *
 * This is used to look through field accessors such as `uri.getPath()`.
 */
private Expr getUnderlyingVarAccess(Expr e) {
  result = getUnderlyingVarAccess(e.(MethodAccess).getQualifier())
  or
  result = e.(VarAccess)
}

private class AllowListGuard extends Guard instanceof MethodAccess {
  AllowListGuard() {
    (isStringPartialMatch(this) or isPathPartialMatch(this)) and
    not isDisallowedWord(super.getAnArgument())
  }

  Expr getCheckedExpr() { result = getUnderlyingVarAccess(super.getQualifier()) }
}

/**
 * Holds if `g` is a guard that considers a path safe because it is checked against an allowlist of partial trusted values.
 * This requires additional protection against path traversal, either another guard (`PathTraversalGuard`)
 * or a sanitizer (`PathNormalizeSanitizer`), to ensure any internal `..` components are removed from the path.
 */
private predicate allowListGuard(Guard g, Expr e, boolean branch) {
  e = g.(AllowListGuard).getCheckedExpr() and
  branch = true and
  (
    // Either a path normalization sanitizer comes before the guard,
    exists(PathNormalizeSanitizer sanitizer | DataFlow::localExprFlow(sanitizer, e))
    or
    // or a check like `!path.contains("..")` comes before the guard
    exists(PathTraversalGuard previousGuard |
      DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
      previousGuard.controls(g.getBasicBlock().(ConditionBlock), false)
    )
  )
}

private class AllowListSanitizer extends PathTraversalSanitizer {
  AllowListSanitizer() { this = DataFlow::BarrierGuard<allowListGuard/3>::getABarrierNode() }
}

/**
 * Holds if `g` is a guard that considers a path safe because it is checked for `..` components, having previously
 * been checked for a trusted prefix.
 */
private predicate dotDotCheckGuard(Guard g, Expr e, boolean branch) {
  e = g.(PathTraversalGuard).getCheckedExpr() and
  branch = false and
  // The same value has previously been checked against a list of allowed prefixes:
  exists(AllowListGuard previousGuard |
    DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
    previousGuard.controls(g.getBasicBlock().(ConditionBlock), true)
  )
}

private class DotDotCheckSanitizer extends PathTraversalSanitizer {
  DotDotCheckSanitizer() { this = DataFlow::BarrierGuard<dotDotCheckGuard/3>::getABarrierNode() }
}

private class BlockListGuard extends Guard instanceof MethodAccess {
  BlockListGuard() {
    (isStringPartialMatch(this) or isPathPartialMatch(this)) and
    isDisallowedWord(super.getAnArgument())
  }

  Expr getCheckedExpr() { result = getUnderlyingVarAccess(super.getQualifier()) }
}

/**
 * Holds if `g` is a guard that considers a string safe because it is checked against a blocklist of known dangerous values.
 * This requires a prior check for URL encoding concealing a forbidden value, either a guard (`UrlEncodingGuard`)
 * or a sanitizer (`UrlDecodeSanitizer`).
 */
private predicate blockListGuard(Guard g, Expr e, boolean branch) {
  e = g.(BlockListGuard).getCheckedExpr() and
  branch = false and
  (
    // Either `e` has been URL decoded:
    exists(UrlDecodeSanitizer sanitizer | DataFlow::localExprFlow(sanitizer, e))
    or
    // or `e` has previously been checked for URL encoding sequences:
    exists(UrlEncodingGuard previousGuard |
      DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
      previousGuard.controls(g.getBasicBlock(), false)
    )
  )
}

private class BlockListSanitizer extends PathTraversalSanitizer {
  BlockListSanitizer() { this = DataFlow::BarrierGuard<blockListGuard/3>::getABarrierNode() }
}

/**
 * Holds if `g` is a guard that considers a string safe because it is checked for URL encoding sequences,
 * having previously been checked against a block-list of forbidden values.
 */
private predicate urlEncodingGuard(Guard g, Expr e, boolean branch) {
  e = g.(UrlEncodingGuard).getCheckedExpr() and
  branch = false and
  exists(BlockListGuard previousGuard |
    DataFlow::localExprFlow(previousGuard.getCheckedExpr(), e) and
    previousGuard.controls(g.getBasicBlock(), false)
  )
}

private class UrlEncodingSanitizer extends PathTraversalSanitizer {
  UrlEncodingSanitizer() { this = DataFlow::BarrierGuard<urlEncodingGuard/3>::getABarrierNode() }
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
class PathTraversalGuard extends Guard instanceof MethodAccess {
  PathTraversalGuard() {
    super.getMethod().getDeclaringType() instanceof TypeString and
    super.getMethod().hasName(["contains", "indexOf"]) and
    super.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".."
  }

  Expr getCheckedExpr() { result = getUnderlyingVarAccess(super.getQualifier()) }
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

/** A node with path normalization. */
class NormalizedPathNode extends DataFlow::Node {
  NormalizedPathNode() {
    TaintTracking::localExprTaint(this.asExpr(), any(PathNormalizeSanitizer ma))
  }
}

/** Data model related to `java.nio.file.Path`. */
private class PathDataModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.nio.file;Paths;true;get;;;Argument[0];ReturnValue;taint;manual",
        "java.nio.file;Path;true;normalize;;;Argument[-1];ReturnValue;taint;manual"
      ]
  }
}
