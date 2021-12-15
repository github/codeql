/**
 * @name User-controlled data used in permissions check
 * @description Using user-controlled data in a permissions check may result in inappropriate
 *              permissions being granted.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/tainted-permissions-check
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class TypeShiroSubject extends RefType {
  TypeShiroSubject() { this.getQualifiedName() = "org.apache.shiro.subject.Subject" }
}

class TypeShiroWCPermission extends RefType {
  TypeShiroWCPermission() {
    this.getQualifiedName() = "org.apache.shiro.authz.permission.WildcardPermission"
  }
}

abstract class PermissionsConstruction extends Top {
  abstract Expr getInput();
}

class PermissionsCheckMethodAccess extends MethodAccess, PermissionsConstruction {
  PermissionsCheckMethodAccess() {
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

class WCPermissionConstruction extends ClassInstanceExpr, PermissionsConstruction {
  WCPermissionConstruction() {
    this.getConstructor().getDeclaringType() instanceof TypeShiroWCPermission
  }

  override Expr getInput() { result = this.getArgument(0) }
}

class TaintedPermissionsCheckFlowConfig extends TaintTracking::Configuration {
  TaintedPermissionsCheckFlowConfig() { this = "TaintedPermissionsCheckFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UserInput }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(PermissionsConstruction p).getInput()
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, PermissionsConstruction p,
  TaintedPermissionsCheckFlowConfig conf
where sink.getNode().asExpr() = p.getInput() and conf.hasFlowPath(source, sink)
select p, source, sink, "Permissions check uses user-controlled $@.", source.getNode(), "data"
