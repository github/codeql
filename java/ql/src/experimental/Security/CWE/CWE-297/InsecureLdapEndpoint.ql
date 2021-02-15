/**
 * @name Insecure LDAP Endpoint Configuration
 * @description Java application configured to disable LDAP endpoint identification does not validate the SSL certificate to properly ensure that it is actually associated with that host.
 * @kind problem
 * @id java/insecure-ldap-endpoint
 * @tags security
 *       external/cwe-297
 */

import java

/**
 * The method to set a system property.
 */
class SetSystemPropertyMethod extends Method {
  SetSystemPropertyMethod() {
    this.hasName("setProperty") and
    this.getDeclaringType().hasQualifiedName("java.lang", "System")
  }
}

/**
 * The method to set Java properties.
 */
class SetPropertyMethod extends Method {
  SetPropertyMethod() {
    this.hasName("setProperty") and
    this.getDeclaringType().hasQualifiedName("java.util", "Properties")
  }
}

/**
 * The method to set system properties.
 */
class SetSystemPropertiesMethod extends Method {
  SetSystemPropertiesMethod() {
    this.hasName("setProperties") and
    this.getDeclaringType().hasQualifiedName("java.lang", "System")
  }
}

/** Holds if `MethodAccess` ma disables SSL endpoint check. */
predicate isInsecureSSLEndpoint(MethodAccess ma) {
  (
    ma.getMethod() instanceof SetSystemPropertyMethod and
    (
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() =
        "com.sun.jndi.ldap.object.disableEndpointIdentification" and
      ma.getArgument(1).(CompileTimeConstantExpr).getStringValue() = "true" //com.sun.jndi.ldap.object.disableEndpointIdentification=true
    )
    or
    ma.getMethod() instanceof SetSystemPropertiesMethod and
    exists(MethodAccess ma2 |
      ma2.getMethod() instanceof SetPropertyMethod and
      ma2.getArgument(0).(CompileTimeConstantExpr).getStringValue() =
        "com.sun.jndi.ldap.object.disableEndpointIdentification" and
      ma2.getArgument(1).(CompileTimeConstantExpr).getStringValue() = "true" and //com.sun.jndi.ldap.object.disableEndpointIdentification=true
      ma2.getQualifier().(VarAccess).getVariable().getAnAccess() = ma.getArgument(0) // systemProps.setProperties(properties)
    )
  )
}

from MethodAccess ma
where isInsecureSSLEndpoint(ma)
select ma, "SSL configuration allows insecure endpoint configuration"
