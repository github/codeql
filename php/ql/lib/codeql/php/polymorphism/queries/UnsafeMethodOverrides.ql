/**
 * @name Unsafe Method Overrides
 * @description Finds method overrides that could break security assumptions
 * @kind problem
 * @problem.severity error
 * @security-severity high
 * @precision high
 * @tags security
 *       polymorphism
 *       method-override
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.OverrideValidation
import codeql.php.polymorphism.VulnerabilityDetection

/**
 * Detects method overrides with incompatible signatures
 */
from Method overridingMethod, Method overriddenMethod
where
  // Same method name
  overridingMethod.getName() = overriddenMethod.getName() and
  // In subclass relationship
  exists(Class sub, Class sup |
    isSubclassOf(sub, sup) and
    sub.getMethod(overridingMethod.getName()) = overridingMethod and
    sup.getMethod(overriddenMethod.getName()) = overriddenMethod
  ) and
  // Signatures don't match
  not hasCompletelyCompatibleSignature(overridingMethod, overriddenMethod)
select overridingMethod,
  "Unsafe override of method " + overriddenMethod.getName() +
    " in class " + overridingMethod.getDeclaringClass().getName() +
    " - signatures are incompatible"
