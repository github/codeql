/**
 * @name Insecure LDAP authentication
 * @description LDAP authentication with credentials sent in cleartext.
 * @kind path-problem
 * @id java/insecure-ldap-auth
 * @tags security
 *       external/cwe-522
 *       external/cwe-319
 */

import java
import semmle.code.java.frameworks.Jndi
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * Gets a regular expression for matching private hosts, which only matches the host portion therefore checking for port is not necessary.
 */
private string getPrivateHostRegex() {
  result =
    "(?i)localhost(?:[:/?#].*)?|127\\.0\\.0\\.1(?:[:/?#].*)?|10(?:\\.[0-9]+){3}(?:[:/?#].*)?|172\\.16(?:\\.[0-9]+){2}(?:[:/?#].*)?|192.168(?:\\.[0-9]+){2}(?:[:/?#].*)?|\\[?0:0:0:0:0:0:0:1\\]?(?:[:/?#].*)?|\\[?::1\\]?(?:[:/?#].*)?"
}

/**
 * String of LDAP connections not in private domains.
 */
class LdapStringLiteral extends StringLiteral {
  LdapStringLiteral() {
    // Match connection strings with the LDAP protocol and without private IP addresses to reduce false positives.
    exists(string s | this.getRepresentedString() = s |
      s.regexpMatch("(?i)ldap://[\\[a-zA-Z0-9].*") and
      not s.substring(7, s.length()).regexpMatch(getPrivateHostRegex())
    )
  }
}

/** The interface `javax.naming.Context`. */
class TypeNamingContext extends Interface {
  TypeNamingContext() { this.hasQualifiedName("javax.naming", "Context") }
}

/** The class `java.util.Hashtable`. */
class TypeHashtable extends Class {
  TypeHashtable() { this.getSourceDeclaration().hasQualifiedName("java.util", "Hashtable") }
}

/**
 * Holds if a non-private LDAP string is concatenated from both protocol and host.
 */
predicate concatLdapString(Expr protocol, Expr host) {
  (
    protocol.(CompileTimeConstantExpr).getStringValue().regexpMatch("(?i)ldap(://)?") or
    protocol
        .(VarAccess)
        .getVariable()
        .getAnAssignedValue()
        .(CompileTimeConstantExpr)
        .getStringValue()
        .regexpMatch("(?i)ldap(://)?")
  ) and
  not exists(string hostString |
    hostString = host.(CompileTimeConstantExpr).getStringValue() or
    hostString =
      host.(VarAccess).getVariable().getAnAssignedValue().(CompileTimeConstantExpr).getStringValue()
  |
    hostString.length() = 0 or // Empty host is loopback address
    hostString.regexpMatch(getPrivateHostRegex())
  )
}

/** Gets the leftmost operand in a concatenated string */
Expr getLeftmostConcatOperand(Expr expr) {
  if expr instanceof AddExpr
  then result = getLeftmostConcatOperand(expr.(AddExpr).getLeftOperand())
  else result = expr
}

/**
 * String concatenated with `LdapStringLiteral`.
 */
class LdapString extends Expr {
  LdapString() {
    this instanceof LdapStringLiteral
    or
    concatLdapString(this.(AddExpr).getLeftOperand(),
      getLeftmostConcatOperand(this.(AddExpr).getRightOperand()))
  }
}

/**
 * Tainted value passed to env `Hashtable` as the provider URL, i.e.
 * `env.put(Context.PROVIDER_URL, tainted)` or `env.setProperty(Context.PROVIDER_URL, tainted)`.
 */
predicate isProviderUrlEnv(MethodAccess ma) {
  ma.getMethod().getDeclaringType().getAnAncestor() instanceof TypeHashtable and
  (ma.getMethod().hasName("put") or ma.getMethod().hasName("setProperty")) and
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
 * Holds if the value "simple" is passed to env `Hashtable` as the authentication mechanism, i.e.
 * `env.put(Context.SECURITY_AUTHENTICATION, "simple")` or `env.setProperty(Context.SECURITY_AUTHENTICATION, "simple")`.
 */
predicate isSimpleAuthEnv(MethodAccess ma) {
  ma.getMethod().getDeclaringType().getAnAncestor() instanceof TypeHashtable and
  (ma.getMethod().hasName("put") or ma.getMethod().hasName("setProperty")) and
  (
    ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() =
      "java.naming.security.authentication"
    or
    exists(Field f |
      ma.getArgument(0) = f.getAnAccess() and
      f.hasName("SECURITY_AUTHENTICATION") and
      f.getDeclaringType() instanceof TypeNamingContext
    )
  ) and
  ma.getArgument(1).(CompileTimeConstantExpr).getStringValue() = "simple"
}

/**
 * A taint-tracking configuration for cleartext credentials in LDAP authentication.
 */
class LdapAuthFlowConfig extends TaintTracking::Configuration {
  LdapAuthFlowConfig() { this = "InsecureLdapAuth:LdapAuthFlowConfig" }

  /** Source of non-private LDAP connection string */
  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof LdapString }

  /** Sink of provider URL with simple authentication */
  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess pma |
      sink.asExpr() = pma.getArgument(1) and
      isProviderUrlEnv(pma) and
      exists(MethodAccess sma |
        sma.getQualifier() = pma.getQualifier().(VarAccess).getVariable().getAnAccess() and
        isSimpleAuthEnv(sma)
      )
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, LdapAuthFlowConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure LDAP authentication from $@.", source.getNode(),
  "LDAP connection string"
