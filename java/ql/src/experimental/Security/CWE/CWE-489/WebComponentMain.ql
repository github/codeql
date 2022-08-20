/**
 * @name Main Method in Java EE Web Components
 * @description Java EE web applications with a main method.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/main-method-in-web-components
 * @tags security
 *       external/cwe/cwe-489
 */

import java
import semmle.code.java.frameworks.Servlets
import TestLib

/** The java type `javax.servlet.Filter`. */
class ServletFilterClass extends Class {
  ServletFilterClass() { this.getAnAncestor().hasQualifiedName("javax.servlet", "Filter") }
}

/** Listener class in the package `javax.servlet` and `javax.servlet.http` */
class ServletListenerClass extends Class {
  // Various listener classes of Java EE such as ServletContextListener. They all have a name ending with the word "Listener".
  ServletListenerClass() {
    this.getAnAncestor()
        .getQualifiedName()
        .regexpMatch([
            "javax\\.servlet\\.[a-zA-Z]+Listener", "javax\\.servlet\\.http\\.[a-zA-Z]+Listener"
          ])
  }
}

/** The `main` method in `Servlet` and `Action` of the Spring and Struts framework. */
class WebComponentMainMethod extends Method {
  WebComponentMainMethod() {
    (
      this.getDeclaringType() instanceof ServletClass or
      this.getDeclaringType() instanceof ServletFilterClass or
      this.getDeclaringType() instanceof ServletListenerClass or
      this.getDeclaringType().getAnAncestor().hasQualifiedName("org.apache.struts.action", "Action") or // Struts actions
      this.getDeclaringType()
          .getAStrictAncestor()
          .hasQualifiedName("com.opensymphony.xwork2", "ActionSupport") or // Struts 2 actions
      this.getDeclaringType()
          .getAStrictAncestor()
          .hasQualifiedName("org.springframework.web.struts", "ActionSupport") or // Spring/Struts 2 actions
      this.getDeclaringType()
          .getAStrictAncestor()
          .hasQualifiedName("org.springframework.webflow.execution", "Action") // Spring actions
    ) and
    this instanceof MainMethod and
    not isTestMethod(this)
  }
}

from WebComponentMainMethod sm
select sm, "Web application has a main method."
