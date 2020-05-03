import java
import semmle.code.java.dataflow.FlowSources
import DataFlow
import experimental.semmle.code.java.frameworks.Jndi
import experimental.semmle.code.java.frameworks.spring.SpringJndi
import semmle.code.java.frameworks.SpringLdap
import experimental.semmle.code.java.frameworks.Shiro

/**
 * A taint-tracking configuration for unvalidated user input that is used in JNDI lookup.
 */
class JndiInjectionFlowConfig extends TaintTracking::Configuration {
  JndiInjectionFlowConfig() { this = "JndiInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JndiInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    compositeNameStep(node1, node2) or
    jmxServiceUrlStep(node1, node2) or
    jmxConnectorStep(node1, node2) or
    rmiConnectorStep(node1, node2)
  }
}

/** The interface `javax.management.remote.JMXConnector`. */
class TypeJMXConnector extends Interface {
  TypeJMXConnector() { this.hasQualifiedName("javax.management.remote", "JMXConnector") }
}

/** The class `javax.management.remote.rmi.RMIConnector`. */
class TypeRMIConnector extends Class {
  TypeRMIConnector() { this.hasQualifiedName("javax.management.remote.rmi", "RMIConnector") }
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

/**
 * JNDI sink for JNDI injection vulnerabilities, i.e. 1st argument to `lookup`, `lookupLink`,
 * `doLookup`, `rename`, `list` or `listBindings` method from `InitialContext`.
 */
predicate jndiSinkMethod(Method m, int index) {
  m.getDeclaringType().getAnAncestor() instanceof TypeInitialContext and
  (
    m.hasName("lookup") or
    m.hasName("lookupLink") or
    m.hasName("doLookup") or
    m.hasName("rename") or
    m.hasName("list") or
    m.hasName("listBindings")
  ) and
  index = 0
}

/**
 * Spring sink for JNDI injection vulnerabilities, i.e. 1st argument to `lookup` method from
 * Spring's `JndiTemplate`.
 */
predicate springJndiTemplateSinkMethod(Method m, int index) {
  m.getDeclaringType() instanceof TypeSpringJndiTemplate and
  m.hasName("lookup") and
  index = 0
}

/**
 * Spring sink for JNDI injection vulnerabilities, i.e. 1st argument to `lookup` or `lookupContext`
 * method from Spring's `LdapTemplate`.
 */
predicate springLdapTemplateSinkMethod(Method m, int index) {
  m.getDeclaringType() instanceof TypeSpringLdapTemplate and
  (m.hasName("lookup") or m.hasName("lookupContext")) and
  index = 0
}

/**
 * Apache Shiro sink for JNDI injection vulnerabilities, i.e. 1st argument to `lookup` method from
 * Shiro's `JndiTemplate`.
 */
predicate shiroSinkMethod(Method m, int index) {
  m.getDeclaringType() instanceof TypeShiroJndiTemplate and
  m.hasName("lookup") and
  index = 0
}

/**
 * `JMXConnectorFactory` sink for JNDI injection vulnerabilities, i.e. 1st argument to `connect`
 * method from `JMXConnectorFactory`.
 */
predicate jmxConnectorFactorySinkMethod(Method m, int index) {
  m.getDeclaringType() instanceof TypeJMXConnectorFactory and
  m.hasName("connect") and
  index = 0
}

/** Holds if parameter at index `index` in method `m` is JNDI injection sink. */
predicate jndiInjectionSinkMethod(Method m, int index) {
  jndiSinkMethod(m, index) or
  springJndiTemplateSinkMethod(m, index) or
  springLdapTemplateSinkMethod(m, index) or
  shiroSinkMethod(m, index) or
  jmxConnectorFactorySinkMethod(m, index)
}

/** A data flow sink for unvalidated user input that is used in JNDI lookup. */
class JndiInjectionSink extends DataFlow::ExprNode {
  JndiInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      jndiInjectionSinkMethod(m, index)
    )
    or
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      ma.getQualifier() = this.getExpr() and
      m.getDeclaringType().getAnAncestor() instanceof TypeJMXConnector and
      m.hasName("connect")
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `CompositeName`,
 * i.e. `new CompositeName(tainted)`.
 */
predicate compositeNameStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeCompositeName |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `JMXServiceURL`,
 * i.e. `new JMXServiceURL(tainted)`.
 */
predicate jmxServiceUrlStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeJMXServiceURL |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `JMXServiceURL` and
 * `JMXConnector`, i.e. `JMXConnectorFactory.newJMXConnector(tainted)`.
 */
predicate jmxConnectorStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m | n1.asExpr() = ma.getArgument(0) and n2.asExpr() = ma |
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeJMXConnectorFactory and
    m.hasName("newJMXConnector")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `JMXServiceURL` and
 * `RMIConnector`, i.e. `new RMIConnector(tainted)`.
 */
predicate rmiConnectorStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeRMIConnector |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}
