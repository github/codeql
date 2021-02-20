/**
 * @name Main Method in Enterprise Java Bean
 * @description Jave EE applications with a main method.
 * @kind problem
 * @id java/main-method-in-enterprise-bean
 * @tags security
 *       external/cwe-489
 */

import java
import semmle.code.java.J2EE

/** The `main` method in an Enterprise Java Bean. */
class EnterpriseBeanMainMethod extends Method {
  EnterpriseBeanMainMethod() {
    this.getDeclaringType() instanceof EnterpriseBean and
    this.hasName("main") and
    this.isStatic() and
    this.getReturnType() instanceof VoidType and
    this.isPublic() and
    this.getNumberOfParameters() = 1 and
    this.getParameter(0).getType() instanceof Array and
    not this.getDeclaringType().getName().toLowerCase().matches("%test%") and // Simple check to exclude test classes to reduce FPs
    not this.getDeclaringType().getPackage().getName().toLowerCase().matches("%test%") and // Simple check to exclude classes in test packages to reduce FPs
    not exists(this.getLocation().getFile().getAbsolutePath().indexOf("/src/test/java")) //  Match test directory structure of build tools like maven
  }
}

from EnterpriseBeanMainMethod sm
select sm, "Java EE application has a main method."
