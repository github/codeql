/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @id go/ldap-inject
 * @tags security
 *       external/cwe/cwe-090
 */

import go
import DataFlow::PathGraph

/** 
 * The Sanitizer func of ldap inject. 
 */
abstract class LdapSanitizer extends DataFlow::Node {

}
/*
 * The Sanitizer func from github.com/go-ldap/ldap
 */
private class GoLdapEscape extends LdapSanitizer {
    GoLdapEscape() { exists(Function f 
        |f.hasQualifiedName("github.com/go-ldap/ldap", "EscapeFilter")
        |this = f.getACall()) }
}
/*
 * The Sanitizer func from gopkg.in/ldap.v2
 */
private class LdapV2Escape extends LdapSanitizer {
    LdapV2Escape() { exists(Function f 
        |f.hasQualifiedName("github.com/go-ldap/ldap", "EscapeFilter")
        |this = f.getACall()) }
}


/** 
 * The data flow sink of ldap inject. 
 */
abstract class LdapSink extends DataFlow::Node {
}

/*
 * ldap sink from github.com/go-ldap/ldap NewSearchRequest
 */
private class GoLdapSink extends LdapSink{
    GoLdapSink(){exists(Function f 
        | f.hasQualifiedName("github.com/go-ldap/ldap", "NewSearchRequest") 
        | this = f.getACall().getArgument(6) 
        or 
        this = f.getACall().getArgument(7)
    )}
}
/*
 * ldap sink from gopkg.in/ldap.v2 NewSearchRequest
 */
private class LdapV2Sink extends LdapSink{
    LdapV2Sink(){exists(Function f 
        | f.hasQualifiedName("gopkg.in/ldap.v2", "NewSearchRequest") 
        | this = f.getACall().getArgument(6) 
        or 
        this = f.getACall().getArgument(7)
    )}
}

/**
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


