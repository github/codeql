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

abstract private class PathGuard extends Guard {
  abstract Expr getCheckedExpr();
}

private predicate anyNode(DataFlow::Node n) { any() }

private predicate pathGuardNode(DataFlow::Node n) { n.asExpr() = any(PathGuard g).getCheckedExpr() }

private predicate localTaintFlowToPathGuard(Expr e, PathGuard g) {
  TaintTracking::LocalTaintFlow<anyNode/1, pathGuardNode/1>::hasExprFlow(e, g.getCheckedExpr())
}

private class AllowedPrefixGuard extends PathGuard instanceof MethodAccess {
  AllowedPrefixGuard() {
    (isStringPrefixMatch(this) or isPathPrefixMatch(this)) and
    not isDisallowedWord(super.getAnArgument())
  }

  override Expr getCheckedExpr() { result = super.getQualifier() }
}

/**
 * Holds if `g` is a guard that considers a path safe because it is checked against trusted prefixes.
 * This requires additional protection against path traversal, either another guard (`PathTraversalGuard`)
 * or a sanitizer (`PathNormalizeSanitizer`), to ensure any internal `..` components are removed from the path.
 */
private predicate allowedPrefixGuard(Guard g, Expr e, boolean branch) {
  branch = true and
  // Local taint-flow is used here to handle cases where the validated expression comes from the
  // expression reaching the sink, but it's not the same one, e.g.:
  //  File file = source();
  //  String strPath = file.getCanonicalPath();
  //  if (strPath.startsWith("/safe/dir"))
  //    sink(file);
  g instanceof AllowedPrefixGuard and
  localTaintFlowToPathGuard(e, g) and
  exists(Expr previousGuard |
    localTaintFlowToPathGuard(previousGuard.(PathNormalizeSanitizer), g)
    or
    previousGuard
        .(PathTraversalGuard)
        .controls(g.getBasicBlock(), previousGuard.(PathTraversalGuard).getBranch())
  )
}

private class AllowedPrefixSanitizer extends PathInjectionSanitizer {
  AllowedPrefixSanitizer() {
    this = DataFlow::BarrierGuard<allowedPrefixGuard/3>::getABarrierNode() or
    this = ValidationMethod<allowedPrefixGuard/3>::getAValidatedNode()
  }
}

/**
 * Holds if `g` is a guard that considers a path safe because it is checked for `..` components, having previously
 * been checked for a trusted prefix.
 */
private predicate dotDotCheckGuard(Guard g, Expr e, boolean branch) {
  // Local taint-flow is used here to handle cases where the validated expression comes from the
  // expression reaching the sink, but it's not the same one, e.g.:
  //  Path path = source();
  //  String strPath = path.toString();
  //  if (!strPath.contains("..") && strPath.startsWith("/safe/dir"))
  //    sink(path);
  branch = g.(PathTraversalGuard).getBranch() and
  localTaintFlowToPathGuard(e, g) and
  exists(Guard previousGuard |
    previousGuard.(AllowedPrefixGuard).controls(g.getBasicBlock(), true)
    or
    previousGuard.(BlockListGuard).controls(g.getBasicBlock(), false)
  )
}

private class DotDotCheckSanitizer extends PathInjectionSanitizer {
  DotDotCheckSanitizer() {
    this = DataFlow::BarrierGuard<dotDotCheckGuard/3>::getABarrierNode() or
    this = ValidationMethod<dotDotCheckGuard/3>::getAValidatedNode()
  }
}

private class BlockListGuard extends PathGuard instanceof MethodAccess {
  BlockListGuard() {
    (isStringPartialMatch(this) or isPathPrefixMatch(this)) and
    isDisallowedWord(super.getAnArgument())
  }

  override Expr getCheckedExpr() { result = super.getQualifier() }
}

/**
 * Holds if `g` is a guard that considers a string safe because it is checked against a blocklist of known dangerous values.
 * This requires additional protection against path traversal, either another guard (`PathTraversalGuard`)
 * or a sanitizer (`PathNormalizeSanitizer`), to ensure any internal `..` components are removed from the path.
 */
private predicate blockListGuard(Guard g, Expr e, boolean branch) {
  branch = false and
  // Local taint-flow is used here to handle cases where the validated expression comes from the
  // expression reaching the sink, but it's not the same one, e.g.:
  //  File file = source();
  //  String strPath = file.getCanonicalPath();
  //  if (!strPath.contains("..") && !strPath.startsWith("/dangerous/dir"))
  //    sink(file);
  g instanceof BlockListGuard and
  localTaintFlowToPathGuard(e, g) and
  exists(Expr previousGuard |
    localTaintFlowToPathGuard(previousGuard.(PathNormalizeSanitizer), g)
    or
    previousGuard
        .(PathTraversalGuard)
        .controls(g.getBasicBlock(), previousGuard.(PathTraversalGuard).getBranch())
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
  isStringPrefixMatch(ma)
  or
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

private predicate isDisallowedWord(CompileTimeConstantExpr word) {
  word.getStringValue().matches(["/", "\\", "%WEB-INF%", "%/data%"])
}

/** A complementary guard that protects against path traversal, by looking for the literal `..`. */
private class PathTraversalGuard extends PathGuard {
  PathTraversalGuard() {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType() instanceof TypeString and
      ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".."
    |
      this = ma and
      ma.getMethod().hasName("contains")
      or
      exists(EqualityTest eq |
        this = eq and
        ma.getMethod().hasName(["indexOf", "lastIndexOf"]) and
        eq.getAnOperand() = ma and
        eq.getAnOperand().(CompileTimeConstantExpr).getIntValue() = -1
      )
    )
  }

  override Expr getCheckedExpr() {
    exists(MethodAccess ma | ma = this.(EqualityTest).getAnOperand() or ma = this |
      result = ma.getQualifier()
    )
  }

  boolean getBranch() {
    this instanceof MethodAccess and result = false
    or
    result = this.(EqualityTest).polarity()
  }
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
