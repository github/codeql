/**
 * @name Main Method in Enterprise Java Bean
 * @description Java EE applications with a main method.
 * @kind problem
 * @id java/main-method-in-enterprise-bean
 * @tags security
 *       external/cwe-489
 */

import java
import semmle.code.java.J2EE
import MainLib

/** The `main` method in an Enterprise Java Bean. */
class EnterpriseBeanMainMethod extends Method {
  EnterpriseBeanMainMethod() {
    this.getDeclaringType() instanceof EnterpriseBean and
    isMainMethod(this) and
    not isTestMethod(this)
  }
}

from EnterpriseBeanMainMethod sm
select sm, "Java EE application has a main method."
