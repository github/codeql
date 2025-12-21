/**
 * @name Visibility Bypass Vulnerabilities
 * @description Detects polymorphic bypasses of visibility restrictions
 * @kind problem
 * @problem.severity warning
 * @security-severity medium
 * @precision medium
 * @tags security
 *       polymorphism
 *       visibility
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.MethodLookup
import codeql.php.polymorphism.VulnerabilityDetection

/**
 * Detects when a protected or private method in a parent class
 * is made public in a subclass
 */
from MethodCall call, Method publicImpl, Method protectedParent
where
  call.getMethodName() = publicImpl.getName() and
  publicImpl.isPublic() and
  (protectedParent.isProtected() or protectedParent.isPrivate()) and
  protectedParent.getName() = publicImpl.getName() and
  exists(Class sub, Class sup |
    isSubclassOf(sub, sup) and
    sub.getMethod(publicImpl.getName()) = publicImpl and
    sup.getMethod(protectedParent.getName()) = protectedParent
  )
select call,
  "Method " + call.getMethodName() +
    " is public in subclass but protected/private in parent - visibility bypass vulnerability"
