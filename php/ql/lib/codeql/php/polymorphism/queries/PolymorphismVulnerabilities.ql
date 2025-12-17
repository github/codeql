/**
 * @name Polymorphism-Related Security Vulnerabilities
 * @description Detects security vulnerabilities arising from polymorphic method dispatch
 * @kind problem
 * @problem.severity error
 * @security-severity high
 * @precision medium
 * @tags security
 *       polymorphism
 *       type-confusion
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.VulnerabilityDetection
import codeql.php.polymorphism.DataFlowIntegration

/**
 * Detects type confusion vulnerabilities through polymorphic dispatch
 */
from MethodCall call
where
  // Calling method on variable with uncertain type
  exists(Variable var |
    var = call.getObject() and
    // Method could be implemented differently in subclasses
    count(Class c | exists(c.getMethod(call.getMethodName()))) > 1 and
    // No explicit type checking before the call
    not exists(Expr guard |
      // No instanceof or type annotation
      true
    )
  )
select call,
  "Potential type confusion in polymorphic dispatch: method " + call.getMethodName() +
    " has multiple implementations with different security implications"
