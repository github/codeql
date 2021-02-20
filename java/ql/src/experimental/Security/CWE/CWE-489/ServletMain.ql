/**
 * @name Main Method in Java EE Web Components
 * @description Jave EE web applications with a main method.
 * @kind problem
 * @id java/main-method-in-web-components
 * @tags security
 *       external/cwe-489
 */

import java
import semmle.code.java.frameworks.Servlets

/** The java type `javax.servlet.Filter`. */
class ServletFilterClass extends Class {
  ServletFilterClass() { this.getASupertype*().hasQualifiedName("javax.servlet", "Filter") }
}

/** Listener class in the package `javax.servlet` and `javax.servlet.http` */
class ServletListenerClass extends Class {
  // Various listener classes of Java EE such as ServletContextListener. They all have a name ending with the word "Listener".
  ServletListenerClass() {
    this.getASupertype*()
        .getQualifiedName()
        .regexpMatch([
            "javax\\.servlet\\.[a-zA-Z]+Listener", "javax\\.servlet\\.http\\.[a-zA-Z]+Listener"
          ])
  }
}

/** The `main` method in `Servlet`. */
class ServletMainMethod extends Method {
  ServletMainMethod() {
    (
      this.getDeclaringType() instanceof ServletClass or
      this.getDeclaringType() instanceof ServletFilterClass or
      this.getDeclaringType() instanceof ServletListenerClass or
      this.getDeclaringType()
          .getASupertype*()
          .hasQualifiedName("org.apache.struts.action", "Action") or // Struts actions
      this.getDeclaringType()
          .getASupertype+()
          .hasQualifiedName("com.opensymphony.xwork2", "ActionSupport") or // Struts 2 actions
      this.getDeclaringType()
          .getASupertype+()
          .hasQualifiedName("org.springframework.web.struts", "ActionSupport") or // Spring/Struts 2 actions
      this.getDeclaringType()
          .getASupertype+()
          .hasQualifiedName("org.springframework.webflow.execution", "Action") // Spring actions
    ) and
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

from ServletMainMethod sm
select sm, "Web application has a main method."
