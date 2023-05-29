/**
 * Provides modeling for `net-ldap` a ruby library for LDAP.
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for `net-ldap` a ruby library for LDAP.
 */
module NetLdap {
  /**
   * Flow summary for `Net::LDAP.new`. This method establishes a connection to a LDAP server.
   */
  private class LdapSummary extends SummarizedCallable {
    LdapSummary() { this = "Net::LDAP.new" }

    override MethodCall getACall() { result = any(NetLdapConnection l).asExpr().getExpr() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** Net LDAP Api Node */
  private API::Node ldap() { result = API::getTopLevelMember("Net").getMember("LDAP") }

  /** A call that establishes a LDAP Connection */
  private class NetLdapConnection extends DataFlow::CallNode {
    NetLdapConnection() { this in [ldap().getAnInstantiation(), ldap().getAMethodCall(["open"])] }

    predicate useSsl() {
      this.getKeywordArgument("encryption").getConstantValue().isStringlikeValue("simple_tls")
      or
      this.getAMethodCall("encryption")
          .getArgument(0)
          .getConstantValue()
          .isStringlikeValue(":simple_tls")
      or
      this.getAMethodCall("encryption")
          .getKeywordArgument("method")
          .getConstantValue()
          .isStringlikeValue("simple_tls")
    }

    DataFlow::Node getAuthValue(string arg) {
      result = this.getKeywordArgument("auth").(DataFlow::CallNode).getKeywordArgument(arg)
    }
  }

  /** A call that constructs a LDAP query */
  private class NetLdapFilter extends LdapConstruction::Range, DataFlow::CallNode {
    NetLdapFilter() { this = any(ldap().getMember("Filter").getAMethodCall(["eq"])) }

    override DataFlow::Node getQuery() { result = this.getArgument([0, 1]) }
  }

  /** A call considered as a LDAP execution. */
  private class NetLdapExecution extends LdapExecution::Range, DataFlow::CallNode {
    NetLdapExecution() { this = any(NetLdapConnection l).getAMethodCall("search") }

    override DataFlow::Node getQuery() { result = this.getKeywordArgument(_) }
  }

  /** A call considered as a LDAP bind. */
  private class NetLdapBind extends LdapBind::Range, DataFlow::CallNode {
    NetLdapConnection l;

    NetLdapBind() { this = l.getAMethodCall("bind") }

    override DataFlow::Node getHost() {
      (
        result = l.getKeywordArgument("encryption")
        or
        result = l.getAMethodCall("encryption").getArgument(0)
      ) and
      result.getConstantValue().isStringlikeValue(":simple_tls")
    }

    override DataFlow::Node getPassword() {
      result = l.getAuthValue("password") or
      result = l.getAMethodCall("auth").getArgument(1)
    }

    override predicate useSsl() { l.useSsl() }
  }
}
