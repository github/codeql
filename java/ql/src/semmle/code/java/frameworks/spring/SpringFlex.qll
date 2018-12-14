/**
 * Provides classes and predicates for the Spring BlazeDS integration. BlazeDS allows Java applications to integrate with
 * Apache Flex applications, which are ultimately deployed as Adobe Flash applications.
 */

import java
import semmle.code.java.frameworks.spring.SpringBean
import semmle.code.java.frameworks.spring.SpringComponentScan
import semmle.code.java.frameworks.spring.SpringXMLElement

/** Represents a `<remoting-destination>` element in Spring XML files. */
class SpringRemotingDestination extends SpringXMLElement {
  SpringRemotingDestination() { this.getName() = "remoting-destination" }

  /**
   * Gets the bean that this remoting destination refers to.
   */
  SpringBean getSpringBean() {
    result = getParent() or
    result.getBeanIdentifier() = getAttribute("ref").getValue()
  }

  /**
   * Methods that are specifically included when the bean is exposed as a remote destination.
   */
  string getAnIncludeMethod() {
    result = getAttribute("include-methods").getValue().splitAt(",").trim()
  }

  /**
   * Methods that are specifically excluded when the bean is exposed as a remote destination.
   */
  string getAnExcludeMethod() {
    result = getAttribute("exclude-methods").getValue().splitAt(",").trim()
  }
}

/**
 * A class defined as a remoting destination.
 */
class SpringRemotingDestinationClass extends Class {
  SpringRemotingDestinationClass() {
    exists(SpringRemotingDestination remotingDestination |
      this = remotingDestination.getSpringBean().getClass()
    )
    or
    hasAnnotation("org.springframework.flex.remoting", "RemotingDestination") and
    // Must either be a live bean, or a live component.
    (
      this.(SpringComponent).isLive() or
      this instanceof SpringBeanRefType
    )
  }

  /**
   * Gets the XML configuration of the remoting destination, if it was configured in XML.
   */
  SpringRemotingDestination getRemotingDestinationXML() { this = result.getSpringBean().getClass() }

  /**
   * Holds if the class is operating on an "include" or "exclude" basis.
   *
   * The class is operating on an "include" basis if at least one method is specified as an include
   * method, otherwise it operates on an "exclude" basis. If it is operating on an include basis,
   * only those methods specified on the include list are exported. If it is operation on an exclude
   * basis, only those methods that are not marked as excluded are exported.
   */
  predicate isIncluding() {
    exists(Method m | m = getAMethod() |
      m.hasAnnotation("org.springframework.flex.remoting", "RemotingInclude")
    )
    or
    exists(getRemotingDestinationXML().getAnIncludeMethod())
  }

  /**
   * Gets the methods that are exposed through this remoting destination.
   */
  Method getARemotingMethod() {
    result = this.getAMethod() and
    if isIncluding()
    then
      result.hasAnnotation("org.springframework.flex.remoting", "RemotingInclude") or
      result.getName() = getRemotingDestinationXML().getAnIncludeMethod()
    else (
      not result.hasAnnotation("org.springframework.flex.remoting", "RemotingExclude") and
      not result.getName() = getRemotingDestinationXML().getAnExcludeMethod()
    )
  }
}
