import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.frameworks.gwt.GWT
import semmle.code.java.frameworks.Servlets

/**
 * Any class which extends the `Servlet` interface is intended to be constructed reflectively by a
 * servlet container.
 */
class ServletConstructedClass extends ReflectivelyConstructedClass {
  ServletConstructedClass() {
    this instanceof ServletClass and
    // If we have seen any `web.xml` files, this servlet will be considered to be live only if it is
    // referred to as a servlet-class in at least one. If no `web.xml` files are found, we assume
    // that XML extraction was not enabled, and therefore consider all `Servlet` classes as live.
    (
      isWebXMLIncluded()
      implies
      exists(WebServletClass servletClass | this = servletClass.getClass())
    )
  }
}

/**
 * A "Servlet listener" is a class that is intended to be constructed reflectively by a servlet
 * container based upon a `<listener>` tag in the `web.xml` file.
 *
 * Servlet listeners extend one of a number of listener classes.
 */
class ServletListenerClass extends ReflectivelyConstructedClass {
  ServletListenerClass() {
    getAnAncestor() instanceof ServletWebXMLListenerType and
    // If we have seen any `web.xml` files, this listener will be considered to be live only if it is
    // referred to as a listener-class in at least one. If no `web.xml` files are found, we assume
    // that XML extraction was not enabled, and therefore consider all listener classes as live.
    (
      isWebXMLIncluded()
      implies
      exists(WebListenerClass listenerClass | this = listenerClass.getClass())
    )
  }
}

/**
 * Any class which extends the `Filter` interface is intended to be constructed reflectively by a
 * servlet container.
 */
class ServletFilterClass extends ReflectivelyConstructedClass {
  ServletFilterClass() {
    getASupertype*().hasQualifiedName("javax.servlet", "Filter") and
    // If we have seen any `web.xml` files, this filter will be considered to be live only if it is
    // referred to as a filter-class in at least one. If no `web.xml` files are found, we assume
    // that XML extraction was not enabled, and therefore consider all filter classes as live.
    (isWebXMLIncluded() implies exists(WebFilterClass filterClass | this = filterClass.getClass()))
  }
}

/**
 * An entry point into a GWT application.
 */
class GWTEntryPointConstructedClass extends ReflectivelyConstructedClass {
  GWTEntryPointConstructedClass() { this.(GwtEntryPointClass).isLive() }
}

/**
 * Servlets referred to from a GWT module config file.
 */
class GWTServletClass extends ReflectivelyConstructedClass {
  GWTServletClass() {
    this instanceof ServletClass and
    // There must be evidence that GWT is being used, otherwise missing `*.gwt.xml` files could cause
    // all `Servlet`s to be live.
    exists(Package p | p.getName().matches("com.google.gwt%")) and
    (
      isGwtXmlIncluded()
      implies
      exists(GwtServletElement servletElement |
        this.getQualifiedName() = servletElement.getClassName()
      )
    )
  }
}

/**
 * Methods that may be called reflectively by the UiHandler framework.
 */
class GwtUiBinderEntryPoint extends CallableEntryPoint {
  GwtUiBinderEntryPoint() {
    this instanceof GwtUiFactory
    or
    this instanceof GwtUiHandler
    or
    // The UiBinder framework constructs instances of classes specified in the template files. If a
    // no-arg constructor is present, that may be called automatically. Or, if there is a
    // constructor marked as a `UiConstructor`, then that may be called instead.
    this instanceof GwtUiConstructor
    or
    exists(GwtComponentTemplateElement componentElement |
      this.getDeclaringType() = componentElement.getClass() and
      this instanceof Constructor and
      this.getNumberOfParameters() = 0
    )
  }
}

/**
 * Fields that may be reflectively read or written to by the UiBinder framework.
 */
class GwtUiBinderReflectivelyReadField extends ReflectivelyReadField {
  GwtUiBinderReflectivelyReadField() { this instanceof GwtUiField }
}
