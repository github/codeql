/** Provides classes to reason about JNDI injection vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.frameworks.Jndi
private import semmle.code.java.frameworks.SpringLdap

/** A data flow sink for unvalidated user input that is used in JNDI lookup. */
abstract class JndiInjectionSink extends ApiSinkNode { }

/** A sanitizer for JNDI injection vulnerabilities. */
abstract class JndiInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to
 * the `JndiInjectionFlowConfig` configuration.
 */
class JndiInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `JndiInjectionFlowConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A default sink representing methods susceptible to JNDI injection attacks. */
private class DefaultJndiInjectionSink extends JndiInjectionSink {
  DefaultJndiInjectionSink() { sinkNode(this, "jndi-injection") }
}

/**
 * A method that does a JNDI lookup when it receives a specific argument set to `true`.
 */
private class ConditionedJndiInjectionSink extends JndiInjectionSink, DataFlow::ExprNode {
  ConditionedJndiInjectionSink() {
    exists(MethodCall ma, Method m |
      ma.getMethod() = m and
      ma.getArgument(0) = this.asExpr() and
      m.getDeclaringType().getASourceSupertype*() instanceof TypeLdapOperations
    |
      m.hasName("search") and
      ma.getArgument(3).(CompileTimeConstantExpr).getBooleanValue() = true
      or
      m.hasName("unbind") and
      ma.getArgument(1).(CompileTimeConstantExpr).getBooleanValue() = true
    )
  }
}

/**
 * Tainted value passed to env `Hashtable` as the provider URL by calling
 * `env.put(Context.PROVIDER_URL, tainted)` or `env.setProperty(Context.PROVIDER_URL, tainted)`.
 */
private class ProviderUrlJndiInjectionSink extends JndiInjectionSink, DataFlow::ExprNode {
  ProviderUrlJndiInjectionSink() {
    exists(MethodCall ma, Method m |
      ma.getMethod() = m and
      ma.getArgument(1) = this.getExpr()
    |
      m.getDeclaringType().getASourceSupertype*() instanceof TypeHashtable and
      (m.hasName("put") or m.hasName("setProperty")) and
      (
        ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "java.naming.provider.url"
        or
        exists(Field f |
          ma.getArgument(0) = f.getAnAccess() and
          f.hasName("PROVIDER_URL") and
          f.getDeclaringType() instanceof TypeNamingContext
        )
      )
    )
  }
}

/** A set of additional taint steps to consider when taint tracking JNDI injection related data flows. */
private class DefaultJndiInjectionAdditionalTaintStep extends JndiInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    nameStep(node1, node2) or
    nameAddStep(node1, node2) or
    jmxServiceUrlStep(node1, node2) or
    jmxConnectorStep(node1, node2) or
    rmiConnectorStep(node1, node2)
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `CompositeName` or
 * `CompoundName` by calling `new CompositeName(tainted)` or `new CompoundName(tainted)`.
 */
private predicate nameStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof TypeCompositeName or
    cc.getConstructedType() instanceof TypeCompoundName
  |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `CompositeName` or
 * `CompoundName` by calling `new CompositeName().add(tainted)` or `new CompoundName().add(tainted)`.
 */
private predicate nameAddStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(Method m, MethodCall ma |
    ma.getMethod() = m and
    m.hasName("add") and
    (
      m.getDeclaringType() instanceof TypeCompositeName or
      m.getDeclaringType() instanceof TypeCompoundName
    )
  |
    n1.asExpr() = ma.getAnArgument() and
    n2.asExpr() = ma
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `JMXServiceURL`
 * by calling `new JMXServiceURL(tainted)`.
 */
private predicate jmxServiceUrlStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeJmxServiceUrl |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `JMXServiceURL` and
 * `JMXConnector` by calling `JMXConnectorFactory.newJMXConnector(tainted)`.
 */
private predicate jmxConnectorStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m | n1.asExpr() = ma.getArgument(0) and n2.asExpr() = ma |
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeJmxConnectorFactory and
    m.hasName("newJMXConnector")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `JMXServiceURL` and
 * `RMIConnector` by calling `new RMIConnector(tainted)`.
 */
private predicate rmiConnectorStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeRmiConnector |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/** The class `java.util.Hashtable`. */
private class TypeHashtable extends Class {
  TypeHashtable() { this.getSourceDeclaration().hasQualifiedName("java.util", "Hashtable") }
}
