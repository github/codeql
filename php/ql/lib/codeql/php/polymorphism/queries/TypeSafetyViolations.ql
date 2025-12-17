/**
 * @name Type Safety Violations in Polymorphism
 * @description Detects type safety violations in polymorphic dispatch
 * @kind problem
 * @problem.severity warning
 * @security-severity medium
 * @precision medium
 * @tags polymorphism
 *       type-safety
 *       variance
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.VarianceChecking
import codeql.php.polymorphism.PolymorphicTypeChecking

/**
 * Detects covariance violations in return types
 */
from Method overridingMethod, Method overriddenMethod
where
  overridingMethod.getName() = overriddenMethod.getName() and
  exists(Class sub, Class sup |
    isSubclassOf(sub, sup) and
    sub.getMethod(overridingMethod.getName()) = overridingMethod and
    sup.getMethod(overriddenMethod.getName()) = overriddenMethod
  ) and
  // Check return type is less specific (breaks covariance)
  not isCovariantReturnType(
    overridingMethod.getReturnTypeDecl().toString(),
    overriddenMethod.getReturnTypeDecl().toString()
  )
select overridingMethod,
  "Return type of " + overridingMethod.getName() +
    " is not covariant with parent implementation"

union

/**
 * Detects contravariance violations in parameters
 */
from Method overridingMethod, Method overriddenMethod, int paramIndex
where
  overridingMethod.getName() = overriddenMethod.getName() and
  exists(Class sub, Class sup |
    isSubclassOf(sub, sup) and
    sub.getMethod(overridingMethod.getName()) = overridingMethod and
    sup.getMethod(overriddenMethod.getName()) = overriddenMethod
  ) and
  // Check parameter type is more general (breaks contravariance)
  not isContravariantParameterType(
    overridingMethod.getParameter(paramIndex).getType().toString(),
    overriddenMethod.getParameter(paramIndex).getType().toString()
  )
select overridingMethod,
  "Parameter type of " + overridingMethod.getName() +
    " is not contravariant with parent implementation"
