/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module LDAP {
  private module LDAP2 {
    private class LDAP2QueryMethods extends string {
      LDAP2QueryMethods() {
        this in ["search", "search_s", "search_st", "search_ext", "search_ext_s"]
      }
    }

    private class LDAP2Query extends DataFlow::CallCfgNode, LDAPQuery::Range {
      DataFlow::Node ldapNode;
      string ldapPart;
      DataFlow::Node attrs;

      LDAP2Query() {
        exists(DataFlow::AttrRead searchMethod, DataFlow::CallCfgNode initCall |
          this.getFunction() = searchMethod and
          initCall = API::moduleImport("ldap").getMember("initialize").getACall() and
          initCall = searchMethod.getObject().getALocalSource() and
          searchMethod.getAttributeName() instanceof LDAP2QueryMethods and
          (
            (
              ldapNode = this.getArg(2) or
              ldapNode = this.getArgByName("filterstr")
            ) and
            ldapPart = "search_filter"
            or
            ldapNode = this.getArg(0) and
            ldapPart = "DN"
          ) and
          ( // what if they're not set?
            attrs = this.getArg(3) or
            attrs = this.getArgByName("attrlist")
          )
        )
      }

      override DataFlow::Node getLDAPNode() { result = ldapNode }

      override string getLDAPPart() { result = ldapPart }

      override DataFlow::Node getAttrs() { result = attrs }
    }

    private class LDAP2EscapeDN extends DataFlow::CallCfgNode, LDAPEscape::Range {
      DataFlow::Node escapeNode;

      LDAP2EscapeDN() {
        this = API::moduleImport("ldap").getMember("dn").getMember("escape_dn_chars").getACall() and
        escapeNode = this.getArg(0)
      }

      override DataFlow::Node getEscapeNode() { result = escapeNode }
    }
  }
}
