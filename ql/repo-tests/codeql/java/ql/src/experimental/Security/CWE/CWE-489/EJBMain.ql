/**
 * @name Main Method in Enterprise Java Bean
 * @description Java EE applications with a main method.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/main-method-in-enterprise-bean
 * @tags security
 *       external/cwe/cwe-489
 */

import java
import semmle.code.java.J2EE
import TestLib

/** The `main` method in an Enterprise Java Bean. */
class EnterpriseBeanMainMethod extends Method {
  EnterpriseBeanMainMethod() {
    this.getDeclaringType() instanceof EnterpriseBean and
    this instanceof MainMethod and
    not isTestMethod(this)
  }
}

from EnterpriseBeanMainMethod sm
select sm, "Java EE application has a main method."
