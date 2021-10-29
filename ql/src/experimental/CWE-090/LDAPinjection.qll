import go
import DataFlow::PathGraph

/** 
 * The Sanitizer func of ldap inject. 
 */
abstract class LdapSanitizer extends DataFlow::Node {

}
/*
 * The Sanitizer func from github.com/go-ldap/ldap or github.com/go-ldap/ldap/v3
 */
private class GoLdapEscape extends LdapSanitizer {
    GoLdapEscape() { exists(Function f 
        | f.hasQualifiedName(["github.com/go-ldap/ldap","github.com/go-ldap/ldap/v3"], "EscapeFilter")
        | this = f.getACall()) }
}


/*
 * The Sanitizer func from gopkg.in/ldap.v2 or gopkg.in/ldap.v3
 */
private class LdapV2Escape extends LdapSanitizer {
    LdapV2Escape() { exists(Function f 
        | f.hasQualifiedName(["gopkg.in/ldap.v2","gopkg.in/ldap.v3"], "EscapeFilter")
        | this = f.getACall()) }
}


/** 
 * The data flow sink of ldap inject. 
 */
abstract class LdapSink extends DataFlow::Node {
}

/*
 * ldap sink from github.com/go-ldap/ldap or github.com/go-ldap/ldap/v3 NewSearchRequest
 */
private class GoLdapSink extends LdapSink{
    GoLdapSink(){exists(Function f 
        | f.hasQualifiedName(["github.com/go-ldap/ldap","github.com/go-ldap/ldap/v3"], "NewSearchRequest")
        | this = f.getACall().getArgument([0,6,7])
    )}
}

/*
 * ldap sink from gopkg.in/ldap.v2 or gopkg.in/ldap.v3 NewSearchRequest
 */
private class LdapV2Sink extends LdapSink{
    LdapV2Sink(){exists(Function f 
        | f.hasQualifiedName(["gopkg.in/ldap.v2","gopkg.in/ldap.v3"], "NewSearchRequest")
        | this = f.getACall().getArgument([0,6,7]) 
    )}
}

private class LdapV2DNSink extends LdapSink{
    LdapV2DNSink(){exists(Field f, Write w
        | f.hasQualifiedName(["gopkg.in/ldap.v2","gopkg.in/ldap.v3"], "SearchRequest","BaseDN")
        and 
        w.writesField(_, f, this)
    )}
}
/*
 * ldap sink from github.com/jtblin/go-ldap-client or github.com/jtblin/go-ldap-client Authenticate or GetGroupsOfUser
 */
private class LdapClientSink extends LdapSink{
    LdapClientSink(){exists(Method m
        | m.hasQualifiedName("github.com/jtblin/go-ldap-client", "LDAPClient","Authenticate")
        or 
          m.hasQualifiedName("github.com/jtblin/go-ldap-client", "LDAPClient","GetGroupsOfUser")       
        | this = m.getACall().getArgument(0) 
    )}
}

private class LdapClientDNSink extends LdapSink{
    LdapClientDNSink(){exists(Field f,Write w
        | f.hasQualifiedName("github.com/jtblin/go-ldap-client","LDAPClient","Base")
        and
        w.writesField(_, f, this)
    )}
}
/*
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * flows into a github.com/go-ldap/ldap newsearchrequest call.
 */
class LdapVul extends TaintTracking::Configuration {
  LdapVul() {
      this = "Ldap inject"
  }
  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { 
      sink instanceof LdapSink
  }
  override predicate isSanitizer(DataFlow::Node sanitizer) {
    super.isSanitizer(sanitizer) or sanitizer instanceof LdapSanitizer
  }
}


