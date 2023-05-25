/**
 * Provides modeling for `net-ldap` a ruby library for LDAP.
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts
private import codeql.ruby.CFG
private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.dataflow.internal.DataFlowPrivate
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.Stdlib
private import codeql.ruby.frameworks.Core

/**
 * Provides modeling for `net-ldap` a ruby library for LDAP.
 */
module NetLdap {
  /**
   * Flow summary for `Net::LDAP.new`. This method establishes a connection to a LDAP server.
   */
  private class LdapSummary extends SummarizedCallable {
    LdapSummary() { this = "Net::LDAP.new" }

    override MethodCall getACall() { result = any(LdapConnection l).asExpr().getExpr() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  private class LdapConnection extends DataFlow::CallNode {
    LdapConnection() {
      this = API::getTopLevelMember("Net").getMember("LDAP").getAnInstantiation() or
      this = API::getTopLevelMember("Net").getMember("LDAP").getAMethodCall(["open"])
    }
  }

  /** A call to ` Net::LDAP::Filter.eq`, considered as a LDAP construction. */
  private class NetLdapConstruction extends LdapConstruction::Range, DataFlow::CallNode {
    DataFlow::Node query;

    NetLdapConstruction() {
      this =
        API::getTopLevelMember("Net").getMember("LDAP").getMember("Filter").getAMethodCall(["eq"]) and
      query = this.getArgument([0, 1])
    }

    override DataFlow::Node getQuery() { result = query }
  }

  /** A call considered as a LDAP execution. */
  private class NetLdapExecution extends LdapExecution::Range, DataFlow::CallNode {
    DataFlow::Node query;

    NetLdapExecution() {
      // detecta cuando la query es una string pej
      // ldap.search(base: "ou=#{name},dc=example,dc=com"
      exists(LdapConnection ldapConnection |
        this = ldapConnection.getAMethodCall("search") and
        query = this.getKeywordArgument(_)
      )
      or
      // ignora esta parte
      exists(LdapConnection ldapConnection, NetLdapConstruction ldapConstruction |
        this = ldapConnection.getAMethodCall("search") and
        ldapConstruction = this.getKeywordArgument(_) and
        query = ldapConstruction
      )
    }

    override DataFlow::Node getQuery() { result = query }
  }
}
