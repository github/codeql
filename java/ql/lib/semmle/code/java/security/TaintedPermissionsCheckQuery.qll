/** Provides classes to reason about tainted permissions check vulnerabilities. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking

/**
 * The `org.apache.shiro.subject.Subject` class.
 */
private class TypeShiroSubject extends RefType {
  TypeShiroSubject() { this.getQualifiedName() = "org.apache.shiro.subject.Subject" }
}

/**
 * The `org.apache.shiro.authz.permission.WildcardPermission` class.
 */
private class TypeShiroWildCardPermission extends RefType {
  TypeShiroWildCardPermission() {
    this.getQualifiedName() = "org.apache.shiro.authz.permission.WildcardPermission"
  }
}

/**
 * An expression that constructs a permission.
 */
abstract class PermissionsConstruction extends Top {
  /** Gets the input to this permission construction. */
  abstract Expr getInput();
}

private class PermissionsCheckMethodCall extends MethodCall, PermissionsConstruction {
  PermissionsCheckMethodCall() {
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType() instanceof TypeShiroSubject and
      m.getName() = "isPermitted"
      or
      m.getName().toLowerCase().matches("%permitted%") and
      m.getNumberOfParameters() = 1
    )
  }

  override Expr getInput() { result = this.getArgument(0) }
}

private class WildCardPermissionConstruction extends ClassInstanceExpr, PermissionsConstruction {
  WildCardPermissionConstruction() {
    this.getConstructor().getDeclaringType() instanceof TypeShiroWildCardPermission
  }

  override Expr getInput() { result = this.getArgument(0) }
}

/**
 * A configuration for tracking flow from user input to a permissions check.
 */
module TaintedPermissionsCheckFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(PermissionsConstruction p).getInput()
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    exists(PermissionsConstruction p |
      sink.asExpr() = p.getInput() and
      result = p.getLocation()
    )
  }
}

/** Tracks flow from user input to a permissions check. */
module TaintedPermissionsCheckFlow = TaintTracking::Global<TaintedPermissionsCheckFlowConfig>;
