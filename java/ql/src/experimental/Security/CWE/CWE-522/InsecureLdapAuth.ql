/**
 * @name Insecure LDAP authentication
 * @description LDAP authentication with credentials sent in cleartext.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/insecure-ldap-auth
 * @tags security
 *       external/cwe/cwe-522
 *       external/cwe/cwe-319
 */

import java
import DataFlow
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.Networking
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * Insecure (non-SSL, non-private) LDAP URL string literal.
 */
class InsecureLdapUrlLiteral extends StringLiteral {
  InsecureLdapUrlLiteral() {
    // Match connection strings with the LDAP protocol and without private IP addresses to reduce false positives.
    exists(string s | this.getValue() = s |
      s.regexpMatch("(?i)ldap://[\\[a-zA-Z0-9].*") and
      not s.substring(7, s.length()) instanceof PrivateHostName
    )
  }
}

/** The class `java.util.Hashtable`. */
class TypeHashtable extends Class {
  TypeHashtable() { this.getSourceDeclaration().hasQualifiedName("java.util", "Hashtable") }
}

/**
 * Holds if a non-private LDAP string is concatenated from both protocol and host.
 */
predicate concatInsecureLdapString(Expr protocol, Expr host) {
  protocol.(CompileTimeConstantExpr).getStringValue() = "ldap://" and
  not exists(string hostString |
    hostString = host.(CompileTimeConstantExpr).getStringValue() or
    hostString =
      host.(VarAccess).getVariable().getAnAssignedValue().(CompileTimeConstantExpr).getStringValue()
  |
    hostString.length() = 0 or // Empty host is loopback address
    hostString instanceof PrivateHostName
  )
}

/** Gets the leftmost operand in a concatenated string */
Expr getLeftmostConcatOperand(Expr expr) {
  if expr instanceof AddExpr
  then result = getLeftmostConcatOperand(expr.(AddExpr).getLeftOperand())
  else result = expr
}

/**
 * String concatenated with `InsecureLdapUrlLiteral`.
 */
class InsecureLdapUrl extends Expr {
  InsecureLdapUrl() {
    this instanceof InsecureLdapUrlLiteral
    or
    concatInsecureLdapString(this.(AddExpr).getLeftOperand(),
      getLeftmostConcatOperand(this.(AddExpr).getRightOperand()))
  }
}

/**
 * Holds if `ma` writes the `java.naming.provider.url` (also known as `Context.PROVIDER_URL`) key of a `Hashtable`.
 */
predicate isProviderUrlSetter(MethodAccess ma) {
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
 * Holds if `ma` sets `fieldValue` to `envValue` in some `Hashtable`.
 */
bindingset[fieldValue, envValue]
predicate hasFieldValueEnv(MethodAccess ma, string fieldValue, string envValue) {
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
predicate hasFieldNameEnv(MethodAccess ma, string fieldName, string envValue) {
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

/**
 * Holds if `ma` sets `java.naming.security.authentication` (also known as `Context.SECURITY_AUTHENTICATION`) to `simple` in some `Hashtable`.
 */
predicate isBasicAuthEnv(MethodAccess ma) {
  hasFieldValueEnv(ma, "java.naming.security.authentication", "simple") or
  hasFieldNameEnv(ma, "SECURITY_AUTHENTICATION", "simple")
}

/**
 * Holds if `ma` sets `java.naming.security.protocol` (also known as `Context.SECURITY_PROTOCOL`) to `ssl` in some `Hashtable`.
 */
predicate isSSLEnv(MethodAccess ma) {
  hasFieldValueEnv(ma, "java.naming.security.protocol", "ssl") or
  hasFieldNameEnv(ma, "SECURITY_PROTOCOL", "ssl")
}

/**
 * A taint-tracking configuration for `ldap://` URL in LDAP authentication.
 */
class InsecureUrlFlowConfig extends TaintTracking::Configuration {
  InsecureUrlFlowConfig() { this = "InsecureLdapAuth:InsecureUrlFlowConfig" }

  /** Source of `ldap://` connection string. */
  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof InsecureLdapUrl }

  /** Sink of directory context creation. */
  override predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }

  /** Method call of `env.put()`. */
  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      pred.asExpr() = ma.getArgument(1) and
      isProviderUrlSetter(ma) and
      succ.asExpr() = ma.getQualifier()
    )
  }
}

/**
 * A taint-tracking configuration for `simple` basic-authentication in LDAP configuration.
 */
class BasicAuthFlowConfig extends DataFlow::Configuration {
  BasicAuthFlowConfig() { this = "InsecureLdapAuth:BasicAuthFlowConfig" }

  /** Source of `simple` configuration. */
  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isBasicAuthEnv(ma) and ma.getQualifier() = src.(PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  /** Sink of directory context creation. */
  override predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}

/**
 * A taint-tracking configuration for `ssl` configuration in LDAP authentication.
 */
class SSLFlowConfig extends DataFlow::Configuration {
  SSLFlowConfig() { this = "InsecureLdapAuth:SSLFlowConfig" }

  /** Source of `ssl` configuration. */
  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isSSLEnv(ma) and ma.getQualifier() = src.(PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  /** Sink of directory context creation. */
  override predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, InsecureUrlFlowConfig config
where
  config.hasFlowPath(source, sink) and
  exists(BasicAuthFlowConfig bc | bc.hasFlowTo(sink.getNode())) and
  not exists(SSLFlowConfig sc | sc.hasFlowTo(sink.getNode()))
select sink.getNode(), source, sink, "Insecure LDAP authentication from $@.", source.getNode(),
  "LDAP connection string"
