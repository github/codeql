/** Provides classes to reason about insecure LDAP authentication. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.frameworks.Networking
private import semmle.code.java.frameworks.Jndi

/**
 * An expression that represents an insecure (non-SSL, non-private) LDAP URL.
 */
class InsecureLdapUrl extends Expr {
  InsecureLdapUrl() {
    this instanceof InsecureLdapUrlLiteral
    or
    // Concatentation of insecure protcol and non-private host:
    // protocol + host + ...
    exists(AddExpr e, CompileTimeConstantExpr protocol, Expr rest, Expr host |
      e = this and
      protocol = e.getLeftOperand() and
      rest = e.getRightOperand() and
      if rest instanceof AddExpr then host = rest.(AddExpr).getLeftOperand() else host = rest
    |
      protocol.getStringValue() = "ldap://" and
      not exists(string hostString | hostString = getHostname(host) |
        hostString.length() = 0 or // Empty host is loopback address
        hostString instanceof PrivateHostName
      )
    )
  }
}

/**
 * A sink representing the construction of a `DirContextEnvironment`.
 */
class InsecureLdapUrlSink extends ApiSinkNode {
  InsecureLdapUrlSink() {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      this.asExpr() = cc.getArgument(0)
    )
  }
}

/**
 * Holds if `ma` sets `java.naming.security.authentication` (also known as `Context.SECURITY_AUTHENTICATION`) to `simple` in some `Hashtable`.
 */
predicate isBasicAuthEnv(MethodCall ma) {
  hasFieldValueEnv(ma, "java.naming.security.authentication", "simple") or
  hasFieldNameEnv(ma, "SECURITY_AUTHENTICATION", "simple")
}

/**
 * Holds if `ma` sets `java.naming.security.protocol` (also known as `Context.SECURITY_PROTOCOL`) to `ssl` in some `Hashtable`.
 */
predicate isSslEnv(MethodCall ma) {
  hasFieldValueEnv(ma, "java.naming.security.protocol", "ssl") or
  hasFieldNameEnv(ma, "SECURITY_PROTOCOL", "ssl")
}

/**
 * Holds if `ma` writes the `java.naming.provider.url` (also known as `Context.PROVIDER_URL`) key of a `Hashtable`.
 */
predicate isProviderUrlSetter(MethodCall ma) {
  ma.getMethod().getDeclaringType().getAnAncestor() instanceof TypeHashtable and
  ma.getMethod().hasName(["put", "setProperty"]) and
  (
    ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "java.naming.provider.url"
    or
    exists(Field f |
      ma.getArgument(0) = f.getAnAccess() and
      f.hasName("PROVIDER_URL") and
      f.getDeclaringType() instanceof TypeNamingContext
    )
  )
}

/**
 * An insecure (non-SSL, non-private) LDAP URL string literal.
 */
private class InsecureLdapUrlLiteral extends StringLiteral {
  InsecureLdapUrlLiteral() {
    // Match connection strings with the LDAP protocol and without private IP addresses to reduce false positives.
    exists(string s | this.getValue() = s |
      s.regexpMatch("(?i)ldap://[\\[a-zA-Z0-9].*") and
      not s.substring(7, s.length()) instanceof PrivateHostName
    )
  }
}

/** The class `java.util.Hashtable`. */
private class TypeHashtable extends Class {
  TypeHashtable() { this.getSourceDeclaration().hasQualifiedName("java.util", "Hashtable") }
}

/** Get the string value of an expression representing a hostname. */
private string getHostname(Expr expr) {
  result = expr.(CompileTimeConstantExpr).getStringValue() or
  result =
    expr.(VarAccess).getVariable().getAnAssignedValue().(CompileTimeConstantExpr).getStringValue()
}

/**
 * Holds if `ma` sets `fieldValue` to `envValue` in some `Hashtable`.
 */
bindingset[fieldValue, envValue]
private predicate hasFieldValueEnv(MethodCall ma, string fieldValue, string envValue) {
  // environment.put("java.naming.security.authentication", "simple")
  ma.getMethod().getDeclaringType().getAnAncestor() instanceof TypeHashtable and
  ma.getMethod().hasName(["put", "setProperty"]) and
  ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = fieldValue and
  ma.getArgument(1).(CompileTimeConstantExpr).getStringValue() = envValue
}

/**
 * Holds if `ma` sets attribute name `fieldName` to `envValue` in some `Hashtable`.
 */
bindingset[fieldName, envValue]
private predicate hasFieldNameEnv(MethodCall ma, string fieldName, string envValue) {
  // environment.put(Context.SECURITY_AUTHENTICATION, "simple")
  ma.getMethod().getDeclaringType().getAnAncestor() instanceof TypeHashtable and
  ma.getMethod().hasName(["put", "setProperty"]) and
  exists(Field f |
    ma.getArgument(0) = f.getAnAccess() and
    f.hasName(fieldName) and
    f.getDeclaringType() instanceof TypeNamingContext
  ) and
  ma.getArgument(1).(CompileTimeConstantExpr).getStringValue() = envValue
}
