/**
 * @name Disabling SCE
 * @description Disabling strict contextual escaping (SCE) can cause security vulnerabilities.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision very-high
 * @id js/angular/disabling-sce
 * @tags security
 *       maintainability
 *       frameworks/angularjs
 *       external/cwe/cwe-116
 */

import javascript

from MethodCallExpr mce, AngularJS::BuiltinServiceReference service
where
  service.getName() = "$sceProvider" and
  mce = service.getAMethodCall("enabled") and
  mce.getArgument(0).mayHaveBooleanValue(false)
select mce, "Disabling SCE is strongly discouraged."
