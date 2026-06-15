/**
 * @name Main Method in Enterprise Java Bean
 * @description Java EE applications with a main method.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/main-method-in-enterprise-bean
 * @tags security
 *       experimental
 *       external/cwe/cwe-489
 */

import java
import semmle.code.java.J2EE
deprecated import TestLib

/** The `main` method in an Enterprise Java Bean. */
deprecated class EnterpriseBeanMainMethod extends Method {
  EnterpriseBeanMainMethod() {
    this.getDeclaringType() instanceof EnterpriseBean and
    this instanceof MainMethod and
    not isTestMethod(this)
  }
}

deprecated query predicate problems(EnterpriseBeanMainMethod sm, string message) {
  exists(sm) and message = "Java EE application has a main method."
}
