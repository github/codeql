/** Provides classes to reason about JNDI injection vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.SpringLdap

/** A data flow sink for unvalidated user input that is used in JNDI lookup. */
abstract class JndiInjectionSink extends DataFlow::Node { }

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
 * A method that does a JNDI lookup but needs a specific parameter set to `true` to be vulnerable
 */
private class ConditionedJndiInjectionSink extends JndiInjectionSink, DataFlow::ExprNode {
  ConditionedJndiInjectionSink() {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      ma.getAnArgument() = this.asExpr() and
      m.getSourceDeclaration()
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName(["org.springframework.ldap.core", "org.springframework.ldap"],
            "LdapOperations")
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
 * Tainted value passed to env `Hashtable` as the provider URL, i.e.
 * `env.put(Context.PROVIDER_URL, tainted)` or `env.setProperty(Context.PROVIDER_URL, tainted)`.
 */
private class ProviderUrlJndiInjectionSink extends JndiInjectionSink, DataFlow::ExprNode {
  ProviderUrlJndiInjectionSink() {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      ma.getArgument(1) = this.getExpr()
    |
      m.getDeclaringType().getAnAncestor() instanceof TypeHashtable and
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

/** CSV sink models representing methods susceptible to JNDI injection attacks. */
private class DefaultJndiInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.naming;InitialContext;true;lookup;;;Argument[0];jndi-injection",
        "javax.naming;InitialContext;true;lookupLink;;;Argument[0];jndi-injection",
        "javax.naming;InitialContext;true;doLookup;;;Argument[0];jndi-injection",
        "javax.naming;InitialContext;true;rename;;;Argument[0];jndi-injection",
        "javax.naming;InitialContext;true;list;;;Argument[0];jndi-injection",
        "javax.naming;InitialContext;true;listBindings;;;Argument[0];jndi-injection",
        "javax.management.remote;JMXConnector;true;connect;;;Argument[-1];jndi-injection",
        "javax.management.remote;JMXConnectorFactory;false;connect;;;Argument[0];jndi-injection",
        // Spring
        "org.springframework.jndi;JndiTemplate;false;lookup;;;Argument[0];jndi-injection",
        // spring-ldap 1.2.x and newer
        "org.springframework.ldap.core;LdapOperations;true;lookup;;;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;lookupContext;;;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;findByDn;;;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;rename;;;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;list;;;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;listBindings;;;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;search;(Name,String,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;search;(Name,String,int,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;search;(Name,String,int,String[],ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;search;(String,String,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;search;(String,String,int,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;search;(String,String,int,String[],ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;searchForObject;(Name,String,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap.core;LdapOperations;true;searchForObject;(String,String,ContextMapper<T>);;Argument[0];jndi-injection",
        // spring-ldap 1.1.x
        "org.springframework.ldap;LdapOperations;true;lookup;;;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;lookupContext;;;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;findByDn;;;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;rename;;;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;list;;;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;listBindings;;;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;search;(Name,String,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;search;(Name,String,int,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;search;(Name,String,int,String[],ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;search;(String,String,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;search;(String,String,int,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;search;(String,String,int,String[],ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;searchForObject;(Name,String,ContextMapper<T>);;Argument[0];jndi-injection",
        "org.springframework.ldap;LdapOperations;true;searchForObject;(String,String,ContextMapper<T>);;Argument[0];jndi-injection",
        // Shiro
        "org.apache.shiro.jndi;JndiTemplate;false;lookup;;;Argument[0];jndi-injection"
      ]
  }
}

/** A set of additional taint steps to consider when taint tracking JNDI injection related data flows. */
private class DefaultJndiInjectionAdditionalTaintStep extends JndiInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    nameStep(node1, node2) or
    jmxServiceUrlStep(node1, node2) or
    jmxConnectorStep(node1, node2) or
    rmiConnectorStep(node1, node2)
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `CompositeName` or
 * `CompoundName`, i.e. `new CompositeName(tainted)` or `new CompoundName(tainted)`.
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
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `JMXServiceURL`,
 * i.e. `new JMXServiceURL(tainted)`.
 */
private predicate jmxServiceUrlStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeJMXServiceURL |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `JMXServiceURL` and
 * `JMXConnector`, i.e. `JMXConnectorFactory.newJMXConnector(tainted)`.
 */
private predicate jmxConnectorStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
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
private predicate rmiConnectorStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeRMIConnector |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/** The class `java.util.Hashtable`. */
private class TypeHashtable extends Class {
  TypeHashtable() { this.getSourceDeclaration().hasQualifiedName("java.util", "Hashtable") }
}
