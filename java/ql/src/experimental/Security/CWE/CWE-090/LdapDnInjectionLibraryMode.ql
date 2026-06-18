/**
 * @name LDAP distinguished name injection in authentication framework code (library-mode sources)
 * @description Building an LDAP bind distinguished name (DN) from an unescaped login
 *              principal lets an attacker manipulate the DN structure used to
 *              authenticate, potentially bypassing authentication or impersonating
 *              another principal. This variant uses library-boundary sources to find
 *              the defect inside an authentication framework, where the principal
 *              arrives as a method parameter rather than at a remote flow source.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.1
 * @precision medium
 * @id java/ldap-dn-injection-library-mode
 * @tags security
 *       experimental
 *       external/cwe/cwe-090
 */

import java
import semmle.code.java.dataflow.TaintTracking
import LdapDnLibraryModeFlow::PathGraph

/**
 * The `String name` argument of `javax.naming.Context` / `DirContext`
 * `bind` / `rebind` / `lookup` / `lookupLink` / `createSubcontext` -- interpreted as
 * a (composite or distinguished) name when given a `String`.
 *
 * `new javax.naming.ldap.LdapName(String)` is deliberately not used as a sink: it
 * commonly parses an existing certificate or principal DN to read its RDNs (e.g.
 * `new LdapName(cert.getSubjectX500Principal().getName()).getRdns()`), which is not
 * injection. The injection sinks are the positions where a DN string is used to bind,
 * look up, or authenticate.
 */
class JndiNameLookupMethod extends Method {
  JndiNameLookupMethod() {
    this.hasName(["bind", "rebind", "lookup", "lookupLink", "createSubcontext"]) and
    this.getDeclaringType()
        .getAnAncestor*()
        .hasQualifiedName("javax.naming", ["Context", "directory.DirContext"]) and
    this.getParameterType(0) instanceof TypeString
  }
}

/**
 * A call to `Map.put` / `Hashtable.put` whose key is the
 * `javax.naming.Context.SECURITY_PRINCIPAL` constant or the literal string
 * `"java.naming.security.principal"`. The value argument is the bind DN.
 */
class SecurityPrincipalPut extends MethodCall {
  SecurityPrincipalPut() {
    this.getMethod().hasName("put") and
    (
      this.getArgument(0).(FieldRead).getField().hasName("SECURITY_PRINCIPAL")
      or
      this.getArgument(0).(CompileTimeConstantExpr).getStringValue() =
        "java.naming.security.principal"
    )
  }
}

/**
 * The `principal` argument of Apache Shiro
 * `LdapContextFactory.getLdapContext(principal, credentials)` -- the bind DN. This is
 * the sink in Apache Shiro CVE-2026-49268.
 */
class ShiroGetLdapContextMethod extends Method {
  ShiroGetLdapContextMethod() {
    this.hasName("getLdapContext") and
    this.getDeclaringType()
        .getAnAncestor*()
        .hasQualifiedName("org.apache.shiro.realm.ldap", "LdapContextFactory")
  }
}

/**
 * A login-principal accessor: Apache Shiro `AuthenticationToken.getPrincipal` /
 * `getUsername`, Spring Security `Authentication.getName` / `getPrincipal`, or
 * `java.security.Principal.getName`. These return the untrusted login identity inside
 * an authentication framework.
 */
class AuthPrincipalAccessor extends MethodCall {
  AuthPrincipalAccessor() {
    exists(Method m | m = this.getMethod() |
      m.hasName(["getPrincipal", "getUsername"]) and
      m.getDeclaringType()
          .getAnAncestor*()
          .hasQualifiedName("org.apache.shiro.authc",
            ["AuthenticationToken", "UsernamePasswordToken", "HostAuthenticationToken"])
      or
      m.hasName(["getName", "getPrincipal"]) and
      m.getDeclaringType()
          .getAnAncestor*()
          .hasQualifiedName("org.springframework.security.core", "Authentication")
      or
      m.hasName("getName") and
      m.getDeclaringType().getAnAncestor*().hasQualifiedName("java.security", "Principal")
    )
  }
}

/**
 * A `String` parameter of a DN-builder-shaped method, e.g. `getUserDn`,
 * `getUsernameWithSuffix`, `buildDn`, `resolveDn`. An authentication framework
 * receives the untrusted principal here and concatenates it into the bind DN.
 *
 * This source model is name-heuristic: it keys partly off method names. It is a
 * deliberate precision/recall trade for the library case, where there is no remote
 * flow source to anchor on. A framework that builds the DN in a differently named
 * helper is missed; a benign method that matches the name pattern may produce a false
 * positive. Triage a result by confirming the value reaches a real bind sink
 * unescaped.
 */
class DnBuilderParam extends Parameter {
  DnBuilderParam() {
    this.getType() instanceof TypeString and
    exists(string name | name = this.getCallable().getName().toLowerCase() |
      name.matches([
          "get%userdn", "%userdn", "build%dn", "make%dn", "resolve%dn", "create%dn", "to%dn",
          "compute%dn"
        ])
      or
      name.matches("%usernamewithsuffix%")
      or
      name.matches(["get%principal", "build%principal"])
    )
  }
}

/** A call to a recognised RFC 2253 DN escaper, e.g. `javax.naming.ldap.Rdn.escapeValue`. */
class DnEscaperCall extends MethodCall {
  DnEscaperCall() {
    exists(Method m | m = this.getMethod() |
      m.hasName("escapeValue") and
      m.getDeclaringType().hasQualifiedName("javax.naming.ldap", "Rdn")
      or
      m.hasName("nameEncode") and
      m.getDeclaringType().hasQualifiedName("org.springframework.ldap.support", "LdapEncoder")
      or
      m.hasName("encodeForDN")
      or
      m.getName()
          .toLowerCase()
          .matches(["%escapedn%", "%escapeldapdn%", "%encodefordn%", "%escapedistinguished%"])
    )
  }
}

/**
 * A taint-tracking configuration for an unescaped login principal flowing into an
 * LDAP bind DN inside an authentication framework.
 */
module LdapDnLibraryModeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof AuthPrincipalAccessor
    or
    source.asParameter() instanceof DnBuilderParam
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma | ma.getMethod() instanceof JndiNameLookupMethod |
      sink.asExpr() = ma.getArgument(0)
    )
    or
    sink.asExpr() = any(SecurityPrincipalPut p).getArgument(1)
    or
    exists(MethodCall ma | ma.getMethod() instanceof ShiroGetLdapContextMethod |
      sink.asExpr() = ma.getArgument(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) { node.asExpr() instanceof DnEscaperCall }
}

module LdapDnLibraryModeFlow = TaintTracking::Global<LdapDnLibraryModeConfig>;

from LdapDnLibraryModeFlow::PathNode source, LdapDnLibraryModeFlow::PathNode sink
where LdapDnLibraryModeFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "LDAP bind DN depends on a $@ without RFC 2253 distinguished-name escaping.", source.getNode(),
  "library-boundary login principal"
