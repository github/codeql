/**
 * @name Non Production Interface
 * @description Non-Production interface is left behind and vulnerable to attacks.
 * @kind problem
 * @id java/non-production-interface
 * @tags security
 *       external/cwe/cwe-749
 */

import java
import semmle.code.java.frameworks.spring.SpringController

abstract class NonProductionInterface extends Annotation {
  NonProductionInterface() {
    not exists(this.getLocation().getFile().getAbsolutePath().indexOf("/src/test/java"))
  }
}

/** Spring Controller non-production interface. */
class SpringControllerNonProductionInterface extends NonProductionInterface {
  SpringControllerNonProductionInterface() {
    exists(SpringRequestMappingMethod srmm |
      srmm.getAnAnnotation() = this and
      srmm.getNumberOfLinesOfCode() > 3 and
      this.getType() instanceof SpringRequestMappingAnnotationType and
      this.getAValue("value").toString().regexpMatch("(?i).*test.*")
    )
  }
}

/** An annotation type that identifies webservlet. */
class WebServletAnnotation extends AnnotationType {
  WebServletAnnotation() {
    // `@WebServlet` used directly as an annotation.
    hasQualifiedName("javax.servlet.annotation", "WebServlet")
    or
    // `@WebServlet` can be used as a meta-annotation on other annotation types.
    getAnAnnotation().getType() instanceof WebServletAnnotation
  }
}

/** Use the `servlet` subclass of the `@WebServlet` interface. */
class UseWebServletInterfaceClass extends Class {
  UseWebServletInterfaceClass() {
    getAnAnnotation().getType() instanceof WebServletAnnotation and
    getASupertype*().hasQualifiedName("javax.servlet", "Servlet")
  }
}

/** WebServlet non-production interface. */
class WebServletNonProductionInterface extends NonProductionInterface {
  WebServletNonProductionInterface() {
    exists(UseWebServletInterfaceClass wsc |
      wsc.getAnAnnotation() = this and
      this.getAValue("value").toString().regexpMatch("(?i).*test.*")
      or
      this.getAValue("urlPatterns").toString().regexpMatch("(?i).*test.*")
    )
  }
}

from NonProductionInterface npi
select npi, "non production interface is left behind and vulnerable to attacks"
