/**
 * @name Insecure LDAPS Endpoint Configuration
 * @description Java application configured to disable LDAPS endpoint
 *              identification does not validate the SSL certificate to
 *              properly ensure that it is actually associated with that host.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/insecure-ldaps-endpoint
 * @tags security
 *       experimental
 *       external/cwe/cwe-297
 */

import java

/** The method to set a system property. */
class SetSystemPropertyMethod extends Method {
  SetSystemPropertyMethod() {
    this.hasName("setProperty") and
    this.getDeclaringType().hasQualifiedName("java.lang", "System")
  }
}

/** The class `java.util.Hashtable`. */
class TypeHashtable extends Class {
  TypeHashtable() { this.getSourceDeclaration().hasQualifiedName("java.util", "Hashtable") }
}

/**
 * The method to set Java properties either through `setProperty` declared in the class `Properties`
 * or `put` declared in its parent class `HashTable`.
 */
class SetPropertyMethod extends Method {
  SetPropertyMethod() {
    this.getDeclaringType().getAnAncestor() instanceof TypeHashtable and
    this.hasName(["put", "setProperty"])
  }
}

/** The `setProperties` method declared in `java.lang.System`. */
class SetSystemPropertiesMethod extends Method {
  SetSystemPropertiesMethod() {
    this.hasName("setProperties") and
    this.getDeclaringType().hasQualifiedName("java.lang", "System")
  }
}

/**
 * Holds if `Expr` expr is evaluated to the string literal
 * `com.sun.jndi.ldap.object.disableEndpointIdentification`.
 */
predicate isPropertyDisableLdapEndpointId(Expr expr) {
  expr.(CompileTimeConstantExpr).getStringValue() =
    "com.sun.jndi.ldap.object.disableEndpointIdentification"
  or
  exists(Field f |
    expr = f.getAnAccess() and
    f.getAnAssignedValue().(StringLiteral).getValue() =
      "com.sun.jndi.ldap.object.disableEndpointIdentification"
  )
}

/** Holds if an expression is evaluated to the boolean value true. */
predicate isBooleanTrue(Expr expr) {
  expr.(CompileTimeConstantExpr).getStringValue() = "true" // "true"
  or
  expr.(BooleanLiteral).getBooleanValue() = true // true
  or
  exists(MethodCall ma |
    expr = ma and
    ma.getMethod() instanceof ToStringMethod and
    ma.getQualifier().(FieldAccess).getField().hasName("TRUE") and
    ma.getQualifier()
        .(FieldAccess)
        .getField()
        .getDeclaringType()
        .hasQualifiedName("java.lang", "Boolean") // Boolean.TRUE.toString()
  )
}

/** Holds if `ma` is in a test class or method. */
predicate isTestMethod(MethodCall ma) {
  ma.getEnclosingCallable() instanceof TestMethod or
  ma.getEnclosingCallable().getDeclaringType() instanceof TestClass or
  ma.getEnclosingCallable().getDeclaringType().getPackage().getName().matches("%test%") or
  ma.getEnclosingCallable().getDeclaringType().getName().toLowerCase().matches("%test%")
}

/** Holds if `MethodCall` ma disables SSL endpoint check. */
predicate isInsecureSslEndpoint(MethodCall ma) {
  (
    ma.getMethod() instanceof SetSystemPropertyMethod and
    isPropertyDisableLdapEndpointId(ma.getArgument(0)) and
    isBooleanTrue(ma.getArgument(1)) //com.sun.jndi.ldap.object.disableEndpointIdentification=true
    or
    ma.getMethod() instanceof SetSystemPropertiesMethod and
    exists(MethodCall ma2 |
      ma2.getMethod() instanceof SetPropertyMethod and
      isPropertyDisableLdapEndpointId(ma2.getArgument(0)) and
      isBooleanTrue(ma2.getArgument(1)) and //com.sun.jndi.ldap.object.disableEndpointIdentification=true
      ma2.getQualifier().(VarAccess).getVariable().getAnAccess() = ma.getArgument(0) // systemProps.setProperties(properties)
    )
  )
}

deprecated query predicate problems(MethodCall ma, string message) {
  isInsecureSslEndpoint(ma) and
  not isTestMethod(ma) and
  message = "LDAPS configuration allows insecure endpoint identification."
}
