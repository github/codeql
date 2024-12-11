/** Provides classes and predicates to reason about sanitization of path injection vulnerabilities. */

import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.frameworks.kotlin.IO
private import semmle.code.java.frameworks.kotlin.Text

/** A sanitizer that protects against path injection vulnerabilities. */
abstract class PathInjectionSanitizer extends DataFlow::Node { }

/**
 * Provides a set of nodes validated by a method that uses a validation guard.
 */
private module ValidationMethod<DataFlow::guardChecksSig/3 validationGuard> {
  /** Gets a node that is safely guarded by a method that uses the given guard check. */
  DataFlow::Node getAValidatedNode() {
    exists(MethodCall ma, int pos, VarRead rv |
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
      Guard g, SsaImplicitInit var, ControlFlow::ExitNode exit, ControlFlowNode normexit,
      boolean branch
    |
      validationGuard(g, var.getAUse(), branch) and
      var.isParameterDefinition(m.getParameter(arg)) and
      exit.getEnclosingCallable() = m and
      normexit.getANormalSuccessor() = exit and
      1 = strictcount(ControlFlowNode n | n.getANormalSuccessor() = exit)
    |
      exists(ConditionNode conditionNode |
        g = conditionNode.getCondition() and conditionNode.getABranchSuccessor(branch) = exit
      )
      or
      g.controls(normexit.getBasicBlock(), branch)
    )
  }
}

/**
 * Holds if `g` is guard that compares a path to a trusted value.
 */
private predicate exactPathMatchGuard(Guard g, Expr e, boolean branch) {
  exists(MethodCall ma, RefType t |
    t instanceof TypeString or
    t instanceof TypeUri or
    t instanceof TypePath or
    t instanceof TypeFile or
    t.hasQualifiedName("android.net", "Uri") or
    t instanceof StringsKt or
    t instanceof FilesKt
  |
    e = [getVisualQualifier(ma).getUnderlyingExpr(), getVisualArgument(ma, 0)] and
    ma.getMethod().getDeclaringType() = t and
    ma = g and
    getSourceMethod(ma.getMethod()).hasName(["equals", "equalsIgnoreCase"]) and
    branch = true
  )
}

/**
 * A sanitizer that protects against path injection vulnerabilities
 * by checking for a matching path.
 */
class ExactPathMatchSanitizer extends PathInjectionSanitizer {
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

private class AllowedPrefixGuard extends PathGuard instanceof MethodCall {
  AllowedPrefixGuard() {
    (isStringPrefixMatch(this) or isPathPrefixMatch(this)) and
    not isDisallowedWord(super.getAnArgument())
  }

  override Expr getCheckedExpr() { result = getVisualQualifier(this).getUnderlyingExpr() }
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

private class BlockListGuard extends PathGuard instanceof MethodCall {
  BlockListGuard() {
    (isStringPartialMatch(this) or isPathPrefixMatch(this)) and
    isDisallowedWord(super.getAnArgument())
  }

  override Expr getCheckedExpr() { result = getVisualQualifier(this).getUnderlyingExpr() }
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

private class ConstantOrRegex extends Expr {
  ConstantOrRegex() {
    this instanceof CompileTimeConstantExpr or
    this instanceof KtToRegex
  }

  string getStringValue() {
    result = this.(CompileTimeConstantExpr).getStringValue() or
    result = this.(KtToRegex).getExpressionString()
  }
}

private predicate isStringPrefixMatch(MethodCall ma) {
  exists(Method m, RefType t |
    m.getDeclaringType() = t and
    (t instanceof TypeString or t instanceof StringsKt) and
    m = ma.getMethod()
  |
    getSourceMethod(m).hasName("startsWith")
    or
    getSourceMethod(m).hasName("regionMatches") and
    getVisualArgument(ma, 0).(CompileTimeConstantExpr).getIntValue() = 0
    or
    m.hasName("matches") and
    not getVisualArgument(ma, 0).(ConstantOrRegex).getStringValue().matches(".*%")
  )
}

/**
 * Holds if `ma` is a call to a method that checks a partial string match.
 */
private predicate isStringPartialMatch(MethodCall ma) {
  isStringPrefixMatch(ma)
  or
  exists(RefType t | t = ma.getMethod().getDeclaringType() |
    t instanceof TypeString or t instanceof StringsKt
  ) and
  getSourceMethod(ma.getMethod())
      .hasName(["contains", "matches", "regionMatches", "indexOf", "lastIndexOf"])
}

/**
 * Holds if `ma` is a call to a method that checks whether a path starts with a prefix.
 */
private predicate isPathPrefixMatch(MethodCall ma) {
  exists(RefType t | t = ma.getMethod().getDeclaringType() |
    t instanceof TypePath or t instanceof FilesKt
  ) and
  getSourceMethod(ma.getMethod()).hasName("startsWith")
}

private predicate isDisallowedWord(ConstantOrRegex word) {
  word.getStringValue().matches(["/", "\\", "%WEB-INF%", "%/data%"])
}

/** A complementary guard that protects against path traversal, by looking for the literal `..`. */
private class PathTraversalGuard extends PathGuard {
  Expr checkedExpr;

  PathTraversalGuard() {
    exists(MethodCall ma, Method m, RefType t |
      m = ma.getMethod() and
      t = m.getDeclaringType() and
      (t instanceof TypeString or t instanceof StringsKt) and
      checkedExpr = getVisualQualifier(ma).getUnderlyingExpr() and
      ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = ".."
    |
      this = ma and
      getSourceMethod(m).hasName("contains")
      or
      exists(EqualityTest eq |
        this = eq and
        getSourceMethod(m).hasName(["indexOf", "lastIndexOf"]) and
        eq.getAnOperand() = ma and
        eq.getAnOperand().(CompileTimeConstantExpr).getIntValue() = -1
      )
    )
  }

  override Expr getCheckedExpr() { result = checkedExpr }

  boolean getBranch() {
    this instanceof MethodCall and result = false
    or
    result = this.(EqualityTest).polarity()
  }
}

/** A complementary sanitizer that protects against path traversal using path normalization. */
private class PathNormalizeSanitizer extends MethodCall {
  PathNormalizeSanitizer() {
    exists(RefType t | this.getMethod().getDeclaringType() = t |
      (t instanceof TypePath or t instanceof FilesKt) and
      this.getMethod().hasName("normalize")
      or
      t instanceof TypeFile and
      this.getMethod().hasName(["getCanonicalPath", "getCanonicalFile"])
    )
  }
}

/**
 * Gets the qualifier of `ma` as seen in the source code.
 * This is a helper predicate to solve discrepancies between
 * what `getQualifier` actually gets in Java and Kotlin.
 */
private Expr getVisualQualifier(MethodCall ma) {
  if ma.getMethod() instanceof ExtensionMethod
  then
    result = ma.getArgument(ma.getMethod().(ExtensionMethod).getExtensionReceiverParameterIndex())
  else result = ma.getQualifier()
}

/**
 * Gets the argument of `ma` at position `argPos` as seen in the source code.
 * This is a helper predicate to solve discrepancies between
 * what `getArgument` actually gets in Java and Kotlin.
 */
bindingset[argPos]
private Argument getVisualArgument(MethodCall ma, int argPos) {
  if ma.getMethod() instanceof ExtensionMethod
  then
    result =
      ma.getArgument(argPos + ma.getMethod().(ExtensionMethod).getExtensionReceiverParameterIndex() +
          1)
  else result = ma.getArgument(argPos)
}

/**
 * Gets the proxied method if `m` is a Kotlin proxy that supplies default parameter values.
 * Otherwise, just gets `m`.
 */
private Method getSourceMethod(Method m) {
  m = result.getKotlinParameterDefaultsProxy()
  or
  not exists(Method src | m = src.getKotlinParameterDefaultsProxy()) and
  result = m
}

/**
 * A sanitizer that protects against path injection vulnerabilities
 * by extracting the final component of the user provided path.
 *
 * TODO: convert this class to models-as-data if sanitizer support is added
 */
private class FileGetNameSanitizer extends PathInjectionSanitizer {
  FileGetNameSanitizer() {
    exists(MethodCall mc |
      mc.getMethod().hasQualifiedName("java.io", "File", "getName") and
      this.asExpr() = mc
    )
  }
}
