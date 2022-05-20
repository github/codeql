/**
 * @name Interface cannot be implemented
 * @description An interface method that is incompatible with a protected method on
 *              'java.lang.Object' means that the interface cannot be implemented.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/unimplementable-interface
 * @tags maintainability
 *       useless-code
 */

import java

Method protectedObjectMethod(string signature) {
  result.getSignature() = signature and
  result.isProtected() and
  result.getDeclaringType() instanceof TypeObject
}

from Method method, Method objMethod, Interface impossible
where
  method.getDeclaringType() = impossible and
  objMethod = protectedObjectMethod(method.getSignature()) and
  not hasDescendant(objMethod.getReturnType(), method.getReturnType())
select method,
  "This method's return type conflicts with Object." + method.getName() +
    " so $@ can never be implemented.", impossible, impossible.getName()
