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
            ldapNode = this.getArg(0) and
            ldapPart = "DN"
            or
            (
              ldapNode = this.getArg(2) or
              ldapNode = this.getArgByName("filterstr")
            ) and
            ldapPart = "search_filter"
          )
        )
      }

      override DataFlow::Node getLDAPNode() { result = ldapNode }

      override string getLDAPPart() { result = ldapPart }

      override DataFlow::Node getAttrs() {
        result = this.getArg(3) or result = this.getArgByName("attrlist")
      }
    }

    private class LDAP2EscapeDN extends DataFlow::CallCfgNode, LDAPEscape::Range {
      DataFlow::Node escapeNode;

      LDAP2EscapeDN() {
        this = API::moduleImport("ldap").getMember("dn").getMember("escape_dn_chars").getACall() and
        escapeNode = this.getArg(0)
      }

      override DataFlow::Node getEscapeNode() { result = escapeNode }
    }

    private class LDAP2EscapeFilter extends DataFlow::CallCfgNode, LDAPEscape::Range {
      DataFlow::Node escapeNode;

      LDAP2EscapeFilter() {
        this =
          API::moduleImport("ldap").getMember("filter").getMember("escape_filter_chars").getACall() and
        escapeNode = this.getArg(0)
      }

      override DataFlow::Node getEscapeNode() { result = escapeNode }
    }
  }

  private module LDAP3 {
    private class LDAP3QueryMethods extends string {
      // pending to dig into this although https://github.com/cannatag/ldap3/blob/21001d9087c0d24c399eec433a261c455b7bc97f/ldap3/core/connection.py#L760
      LDAP3QueryMethods() { this in ["search"] }
    }

    private class LDAP3Query extends DataFlow::CallCfgNode, LDAPQuery::Range {
      DataFlow::Node ldapNode;
      string ldapPart;
      DataFlow::Node attrs;

      LDAP3Query() {
        exists(DataFlow::AttrRead searchMethod, DataFlow::CallCfgNode connCall |
          this.getFunction() = searchMethod and
          connCall = API::moduleImport("ldap3").getMember("Connection").getACall() and
          connCall = searchMethod.getObject().getALocalSource() and
          searchMethod.getAttributeName() instanceof LDAP3QueryMethods and
          (
            ldapNode = this.getArg(0) and
            ldapPart = "DN"
            or
            ldapNode = this.getArg(1) and
            ldapPart = "search_filter"
          )
        )
      }

      override DataFlow::Node getLDAPNode() { result = ldapNode }

      override string getLDAPPart() { result = ldapPart }

      override DataFlow::Node getAttrs() {
        result = this.getArg(3) or result = this.getArgByName("attributes")
      }
    }

    private class LDAP3EscapeDN extends DataFlow::CallCfgNode, LDAPEscape::Range {
      DataFlow::Node escapeNode;

      LDAP3EscapeDN() {
        this =
          API::moduleImport("ldap3")
              .getMember("utils")
              .getMember("dn")
              .getMember("escape_rdn")
              .getACall() and
        escapeNode = this.getArg(0)
      }

      override DataFlow::Node getEscapeNode() { result = escapeNode }
    }

    private class LDAP3EscapeFilter extends DataFlow::CallCfgNode, LDAPEscape::Range {
      DataFlow::Node escapeNode;

      LDAP3EscapeFilter() {
        this =
          API::moduleImport("ldap3")
              .getMember("utils")
              .getMember("conv")
              .getMember("escape_filter_chars")
              .getACall() and
        escapeNode = this.getArg(0)
      }

      override DataFlow::Node getEscapeNode() { result = escapeNode }
    }
  }
}
