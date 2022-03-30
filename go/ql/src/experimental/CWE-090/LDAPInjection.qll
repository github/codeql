import go
import DataFlow::PathGraph

/**
 * A sanitizer function that prevents LDAP injection attacks.
 */
abstract class LdapSanitizer extends DataFlow::Node { }

/**
 * A common sanitizer function. These are name-based heuristics only.
 */
private class CommonLdapEscape extends LdapSanitizer {
  CommonLdapEscape() {
    exists(DataFlow::MethodCallNode m |
      m.getTarget().getName() in [
          "sanitizedUserQuery", "sanitizedUserDN", "sanitizedGroupFilter", "sanitizedGroupDN"
        ]
    |
      this = m.getResult(0)
    )
  }
}

/**
 * An `EscapeFilter` function from the `go-ldap` or `ldap` packages.
 */
private class EscapeFilterCall extends LdapSanitizer {
  EscapeFilterCall() {
    exists(Function f |
      f.hasQualifiedName([
          "github.com/go-ldap/ldap", "github.com/go-ldap/ldap/v3", "gopkg.in/ldap.v2",
          "gopkg.in/ldap.v3"
        ], "EscapeFilter")
    |
      this = f.getACall()
    )
  }
}

/**
 * A sink that is vulnerable to LDAP injection vulnerabilities.
 */
abstract class LdapSink extends DataFlow::Node { }

/**
 * A vulnerable argument to `go-ldap` or `ldap`'s `NewSearchRequest` function.
 */
private class GoLdapSink extends LdapSink {
  GoLdapSink() {
    exists(Function f |
      f.hasQualifiedName([
          "github.com/go-ldap/ldap", "github.com/go-ldap/ldap/v3", "gopkg.in/ldap.v2",
          "gopkg.in/ldap.v3"
        ], "NewSearchRequest")
    |
      this = f.getACall().getArgument([0, 6, 7])
    )
  }
}

/**
 * A value written to the `ldap` package's `SearchRequest.BaseDN` field.
 */
private class LdapV2DNSink extends LdapSink {
  LdapV2DNSink() {
    exists(Field f, Write w |
      f.hasQualifiedName(["gopkg.in/ldap.v2", "gopkg.in/ldap.v3"], "SearchRequest", "BaseDN") and
      w.writesField(_, f, this)
    )
  }
}

/**
 * An argument to `go-ldap-client`'s `LDAPClient.Authenticate` or `.GetGroupsOfUser` function.
 */
private class LdapClientSink extends LdapSink {
  LdapClientSink() {
    exists(Method m |
      m.hasQualifiedName("github.com/jtblin/go-ldap-client", "LDAPClient",
        ["Authenticate", "GetGroupsOfUser"])
    |
      this = m.getACall().getArgument(0)
    )
  }
}

/**
 * A value written to `go-ldap-client`'s `LDAPClient.Base` field.
 */
private class LdapClientDNSink extends LdapSink {
  LdapClientDNSink() {
    exists(Field f, Write w |
      f.hasQualifiedName("github.com/jtblin/go-ldap-client", "LDAPClient", "Base") and
      w.writesField(_, f, this)
    )
  }
}

/**
 * A taint-tracking configuration for reasoning about when an `UntrustedFlowSource`
 * flows into an argument or field that is vulnerable to LDAP injection.
 */
class LdapInjectionConfiguration extends TaintTracking::Configuration {
  LdapInjectionConfiguration() { this = "Ldap injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LdapSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof LdapSanitizer }
}
