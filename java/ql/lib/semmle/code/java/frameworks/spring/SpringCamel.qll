/**
 * Provides classes and predicates for identifying Spring integration for the Apache Camel messaging framework.
 */

import java
import semmle.code.java.frameworks.spring.SpringXMLElement
import semmle.code.java.frameworks.spring.SpringBean

/**
 * An Apache Camel element in a Spring Beans file.
 */
class SpringCamelXMLElement extends SpringXMLElement {
  SpringCamelXMLElement() { getNamespace().getURI() = "http://camel.apache.org/schema/spring" }
}

/**
 * An element in a Spring beans file that defines an Apache Camel context.
 *
 * All Apache Camel Spring elements are nested within a `<camelContext>` or a `<routeContext>`.
 */
class SpringCamelXMLContext extends SpringCamelXMLElement {
  SpringCamelXMLContext() { getName() = "camelContext" }
}

/**
 * An element in a Spring beans file that defines an Apache Camel route context.
 *
 * A `<routeContext>` is a fragment, containing route definitions, that can be included within a
 * `<camelContext>`.
 */
class SpringCamelXMLRouteContext extends SpringCamelXMLElement {
  SpringCamelXMLRouteContext() { getName() = "routeContext" }
}

/**
 * An element in a Spring beans files that defines an Apache Camel route.
 *
 * A Camel `<route>` element defines how messages that match certain criteria are handled by Apache
 * Camel.
 */
class SpringCamelXMLRoute extends SpringCamelXMLElement {
  SpringCamelXMLRoute() {
    // A route must either be in a `<routeContext>` or a `<camelContext>`.
    (
      getParent() instanceof SpringCamelXMLRouteContext or
      getParent() instanceof SpringCamelXMLContext
    ) and
    getName() = "route"
  }
}

/**
 * An element in a Spring bean file that is logically contained in an Apache Camel route.
 */
class SpringCamelXMLRouteElement extends SpringCamelXMLElement {
  SpringCamelXMLRouteElement() {
    getParent() instanceof SpringCamelXMLRoute or
    getParent() instanceof SpringCamelXMLRouteElement
  }
}

/**
 * A reference to a Spring bean in an Apache Camel route defined in a Spring beans file.
 *
 * A Camel `<bean>` definition - which is <b>not</b> the same as a Spring `<bean>` element -
 * specifies a Spring bean that should be called in response to messages that match the enclosing
 * route.
 */
class SpringCamelXMLBeanRef extends SpringCamelXMLRouteElement {
  SpringCamelXMLBeanRef() { getName() = "bean" }

  /**
   * Gets the Spring bean that is referenced by this route bean definition, if any.
   */
  SpringBean getRefBean() { result.getBeanIdentifier() = getAttribute("ref").getValue() }

  /**
   * Gets the RefType referred to by `beanType` attribute, if any.
   *
   * This defines the bean that should be created by Apache Camel as a target of this route. In
   * this case, no pre-existing bean is required.
   */
  RefType getBeanType() { result.getQualifiedName() = getAttribute("beanType").getValue() }
}

/**
 * A declaration of a target in an Apache Camel route defined in a Spring beans file.
 *
 * A Camel `<to>` definition uses the "uri" attribute to define the target. The scheme of the "uri"
 * determines the type of the target. For example, if the scheme is "bean:" then the rest of the uri
 * consists of a bean name and optional method name.
 */
class SpringCamelXMLToElement extends SpringCamelXMLRouteElement {
  SpringCamelXMLToElement() { getName() = "to" }

  /**
   * Gets the URI attribute for this `<to>` element.
   */
  string getURI() { result = getAttribute("uri").getValue() }
}

/**
 * A declaration of a Apache Camel "method" expression defined in a Spring beans file.
 *
 * A `<method>` declaration is used in a context where a Camel Expression is required. The
 * expression represented by this call is to a method on a particular bean, either a Spring bean
 * (when the "ref" or "bean" attributes are used), or a type that should be instantiated as a bean
 * (if "beanType" is used.
 */
class SpringCamelXMLMethodElement extends SpringCamelXMLElement {
  SpringCamelXMLMethodElement() { getName() = "method" }

  /**
   * Gets the `SpringBean` that this method expression refers to.
   */
  SpringBean getRefBean() {
    result.getBeanIdentifier() = getAttribute("ref").getValue() or
    result.getBeanIdentifier() = getAttribute("bean").getValue()
  }

  /**
   * Gets the class based on the `beanType` attribute.
   */
  RefType getBeanType() { result.getQualifiedName() = getAttribute("beanType").getValue() }
}
