/** Provides classes and predicates to reason about sanitization of path injection vulnerabilities. */

import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.SSA

/** A sanitizer that protects against path injection vulnerabilities. */
abstract class PathInjectionSanitizer extends DataFlow::Node { }

/**
 * Provides a set of nodes validated by a method that uses a validation guard.
 */
private module ValidationMethod<DataFlow::guardChecksSig/3 validationGuard> {
  /** Gets a node that is safely guarded by a method that uses the given guard check. */
  DataFlow::Node getAValidatedNode() {
    exists(MethodAccess ma, int pos, RValue rv |
      validationMethod(ma.getMethod(), pos) and
      ma.getArgument(pos) = rv and
      adjacentUseUseSameVar(rv, result.asExpr()) and
      ma.getBasicBlock().bbDominates(result.asExpr().getBasicBlock())
    )
  }

  /**
   * Holds if `m` validates its `arg`th parameter by using `validationGuard`.
   */
  private predicate validationMethod(Method m, int arg) {
    exists(
      Guard g, SsaImplicitInit var, ControlFlowNode exit, ControlFlowNode normexit, boolean branch
    |
      validationGuard(g, var.getAUse(), branch) and
      var.isParameterDefinition(m.getParameter(arg)) and
      exit = m and
      normexit.getANormalSuccessor() = exit and
      1 = strictcount(ControlFlowNode n | n.getANormalSuccessor() = exit)
    |
      g.(ConditionNode).getABranchSuccessor(branch) = exit or
      g.controls(normexit.getBasicBlock(), branch)
    )
  }
}

/**
 * Holds if `g` is guard that compares a path to a trusted value.
 */
private predicate exactPathMatchGuard(Guard g, Expr e, boolean branch) {
  exists(MethodAccess ma, RefType t |
    t instanceof TypeString or
    t instanceof TypeUri or
    t instanceof TypePath or
    t instanceof TypeFile or
    t.hasQualifiedName("android.net", "Uri")
  |
    ma.getMethod().getDeclaringType() = t and
    ma = g and
    ma.getMethod().getName() = ["equals", "equalsIgnoreCase"] and
    e = ma.getQualifier() and
    branch = true
  )
}

private class ExactPathMatchSanitizer extends PathInjectionSanitizer {
  ExactPathMatchSanitizer() {
    this = DataFlow::BarrierGuard<exactPathMatchGuard/3>::getABarrierNode()
    or
    this = ValidationMethod<exactPathMatchGuard/3>::getAValidatedNode()
  }
}

private class AllowListGuard extends Guard instanceof MethodAccess {
  AllowListGuard() {
    (isStringPrefixMatch(this) or isPathPrefixMatch(this)) and
    not isDisallowedPrefix(super.getAnArgument())
  }

  Expr getCheckedExpr() { result = super.getQualifier() }
}

/**
 * Holds if `g` is a guard that considers a path safe because it is checked against an allowlist of partial trusted values.
 * This requires additional protection against path traversal, either another guard (`PathTraversalGuard`)
 * or a sanitizer (`PathNormalizeSanitizer`), to ensure any internal `..` components are removed from the path.
 */
private predicate allowListGuard(Guard g, Expr e, boolean branch) {
  branch = true and
  TaintTracking::localExprTaint(e, g.(AllowListGuard).getCheckedExpr()) and
  exists(MethodAccess previousGuard |
    TaintTracking::localExprTaint(previousGuard.(PathNormalizeSanitizer),
      g.(AllowListGuard).getCheckedExpr())
    or
    previousGuard.(PathTraversalGuard).controls(g.getBasicBlock().(ConditionBlock), false)
  )
}

private class AllowListSanitizer extends PathInjectionSanitizer {
  AllowListSanitizer() {
    this = DataFlow::BarrierGuard<allowListGuard/3>::getABarrierNode() or
    this = ValidationMethod<allowListGuard/3>::getAValidatedNode()
  }
}

/**
 * Holds if `g` is a guard that considers a path safe because it is checked for `..` components, having previously
 * been checked for a trusted prefix.
 */
private predicate dotDotCheckGuard(Guard g, Expr e, boolean branch) {
  branch = false and
  TaintTracking::localExprTaint(e, g.(PathTraversalGuard).getCheckedExpr()) and
  exists(MethodAccess previousGuard |
    previousGuard.(AllowListGuard).controls(g.getBasicBlock().(ConditionBlock), true)
    or
    previousGuard.(BlockListGuard).controls(g.getBasicBlock().(ConditionBlock), false)
  )
}

private class DotDotCheckSanitizer extends PathInjectionSanitizer {
  DotDotCheckSanitizer() {
    this = DataFlow::BarrierGuard<dotDotCheckGuard/3>::getABarrierNode() or
    this = ValidationMethod<dotDotCheckGuard/3>::getAValidatedNode()
  }
}

private class BlockListGuard extends Guard instanceof MethodAccess {
  BlockListGuard() {
    (isStringPrefixMatch(this) or isPathPrefixMatch(this)) and
    isDisallowedPrefix(super.getAnArgument())
    or
    isStringPartialMatch(this) and
    isDisallowedWord(super.getAnArgument())
  }

  Expr getCheckedExpr() { result = super.getQualifier() }
}

/**
 * Holds if `g` is a guard that considers a string safe because it is checked against a blocklist of known dangerous values.
 * This requires additional protection against path traversal, either another guard (`PathTraversalGuard`)
 * or a sanitizer (`PathNormalizeSanitizer`), to ensure any internal `..` components are removed from the path.
 */
private predicate blockListGuard(Guard g, Expr e, boolean branch) {
  branch = false and
  TaintTracking::localExprTaint(e, g.(BlockListGuard).getCheckedExpr()) and
  exists(MethodAccess previousGuard |
    TaintTracking::localExprTaint(previousGuard.(PathNormalizeSanitizer),
      g.(BlockListGuard).getCheckedExpr())
    or
    previousGuard.(PathTraversalGuard).controls(g.getBasicBlock().(ConditionBlock), false)
  )
}

private class BlockListSanitizer extends PathInjectionSanitizer {
  BlockListSanitizer() {
    this = DataFlow::BarrierGuard<blockListGuard/3>::getABarrierNode() or
    this = ValidationMethod<blockListGuard/3>::getAValidatedNode()
  }
}

private predicate isStringPrefixMatch(MethodAccess ma) {
  exists(Method m | m = ma.getMethod() and m.getDeclaringType() instanceof TypeString |
    m.hasName("startsWith")
    or
    m.hasName("regionMatches") and
    ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() = 0
    or
    m.hasName("matches") and
    not ma.getArgument(0).(CompileTimeConstantExpr).getStringValue().matches(".*%")
  )
}

/**
 * Holds if `ma` is a call to a method that checks a partial string match.
 */
private predicate isStringPartialMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().hasName(["contains", "matches", "regionMatches", "indexOf", "lastIndexOf"])
}

/**
 * Holds if `ma` is a call to a method that checks whether a path starts with a prefix.
 */
private predicate isPathPrefixMatch(MethodAccess ma) {
  exists(RefType t |
    t instanceof TypePath
    or
    t.hasQualifiedName("kotlin.io", "FilesKt")
  |
    t = ma.getMethod().getDeclaringType() and
    ma.getMethod().hasName("startsWith")
  )
}

private predicate isDisallowedPrefix(CompileTimeConstantExpr prefix) {
  prefix.getStringValue().matches(["%WEB-INF%", "/data%"])
}

private predicate isDisallowedWord(CompileTimeConstantExpr word) {
  word.getStringValue().matches(["/", "\\"])
}

/** A complementary guard that protects against path traversal, by looking for the literal `..`. */
private class PathTraversalGuard extends Guard instanceof MethodAccess {
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
    exists(RefType t |
      t instanceof TypePath or
      t.hasQualifiedName("kotlin.io", "FilesKt")
    |
      this.getMethod().getDeclaringType() = t and
      this.getMethod().hasName("normalize")
    )
    or
    this.getMethod().getDeclaringType() instanceof TypeFile and
    this.getMethod().hasName(["getCanonicalPath", "getCanonicalFile"])
  }
}

/** A node with path normalization. */
class NormalizedPathNode extends DataFlow::Node {
  NormalizedPathNode() {
    TaintTracking::localExprTaint(this.asExpr(), any(PathNormalizeSanitizer ma))
  }
}
