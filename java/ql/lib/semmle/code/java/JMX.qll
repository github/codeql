/**
 * Provides classes and predicates for working with JMX bean types.
 */

import Type

/** A managed bean. */
abstract class ManagedBean extends Interface { }

/** An `MBean`. */
class MBean extends ManagedBean {
  MBean() { this.getQualifiedName().matches("%MBean%") }
}

/** An `MXBean`. */
class MXBean extends ManagedBean {
  MXBean() {
    this.getQualifiedName().matches("%MXBean%") or
    this.getAnAnnotation().getType().hasQualifiedName("javax.management", "MXBean")
  }
}

/**
 * An managed bean implementation which is seen to be registered with the `MBeanServer`, directly or
 * indirectly.
 */
class RegisteredManagedBeanImpl extends Class {
  RegisteredManagedBeanImpl() {
    this.getAnAncestor() instanceof ManagedBean and
    exists(JMXRegistrationCall registerCall | registerCall.getObjectArgument().getType() = this)
  }

  /**
   * Gets a managed bean that this registered bean class implements.
   */
  ManagedBean getAnImplementedManagedBean() { result = this.getAnAncestor() }
}

/**
 * A call that registers an object with the `MBeanServer`, directly or indirectly.
 */
class JMXRegistrationCall extends MethodAccess {
  JMXRegistrationCall() { this.getCallee() instanceof JMXRegistrationMethod }

  /**
   * Gets the argument that represents the object in the registration call.
   */
  Expr getObjectArgument() {
    result = this.getArgument(this.getCallee().(JMXRegistrationMethod).getObjectPosition())
  }
}

/**
 * A method used to register `MBean` and `MXBean` instances with the `MBeanServer`.
 *
 * This is either the `registerMBean` method on `MBeanServer`, or it is a wrapper around that
 * registration method.
 */
class JMXRegistrationMethod extends Method {
  JMXRegistrationMethod() {
    // A direct registration with the `MBeanServer`.
    this.getDeclaringType().hasQualifiedName("javax.management", "MBeanServer") and
    this.getName() = "registerMBean"
    or
    // The `MBeanServer` is often wrapped by an application specific management class, so identify
    // methods that wrap a call to another `JMXRegistrationMethod`.
    exists(JMXRegistrationCall c |
      // This must be a call to another JMX registration method, where the object argument is an access
      // of one of the parameters of this method.
      c.getObjectArgument().(VarAccess).getVariable() = this.getAParameter()
    )
  }

  /**
   * Gets the position of the parameter through which the "object" to be registered is passed.
   */
  int getObjectPosition() {
    // Passed as the first argument to `registerMBean`.
    this.getDeclaringType().hasQualifiedName("javax.management", "MBeanServer") and
    this.getName() = "registerMBean" and
    result = 0
    or
    // Identify the position in this method where the object parameter should be passed.
    exists(JMXRegistrationCall c |
      c.getObjectArgument().(VarAccess).getVariable() = this.getParameter(result)
    )
  }
}

/** The class `javax.management.remote.JMXConnectorFactory`. */
class TypeJMXConnectorFactory extends Class {
  TypeJMXConnectorFactory() {
    this.hasQualifiedName("javax.management.remote", "JMXConnectorFactory")
  }
}

/** The class `javax.management.remote.JMXServiceURL`. */
class TypeJMXServiceURL extends Class {
  TypeJMXServiceURL() { this.hasQualifiedName("javax.management.remote", "JMXServiceURL") }
}

/** The class `javax.management.remote.rmi.RMIConnector`. */
class TypeRMIConnector extends Class {
  TypeRMIConnector() { this.hasQualifiedName("javax.management.remote.rmi", "RMIConnector") }
}
