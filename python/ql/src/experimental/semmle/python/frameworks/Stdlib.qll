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

      LDAP2Query() {
        exists(DataFlow::AttrRead searchMethod, DataFlow::CallCfgNode initCall |
          this.getFunction() = searchMethod and
          initCall = API::moduleImport("ldap").getMember("initialize").getACall() and
          initCall = searchMethod.getObject().getALocalSource() and
          searchMethod.getAttributeName() instanceof LDAP2QueryMethods and
          (
            ldapNode = this.getArg(0)
            or
            (
              ldapNode = this.getArg(2) or
              ldapNode = this.getArgByName("filterstr")
            )
          )
        )
      }

      override DataFlow::Node getLDAPNode() { result = ldapNode }
    }

    private class LDAP2EscapeDNCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP2EscapeDNCall() {
        this = API::moduleImport("ldap").getMember("dn").getMember("escape_dn_chars").getACall()
      }

      override DataFlow::Node getEscapeNode() { result = this.getArg(0) }
    }

    private class LDAP2EscapeFilterCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP2EscapeFilterCall() {
        this =
          API::moduleImport("ldap").getMember("filter").getMember("escape_filter_chars").getACall()
      }

      override DataFlow::Node getEscapeNode() { result = this.getArg(0) }
    }
  }

  private module LDAP3 {
    private class LDAP3QueryMethods extends string {
      LDAP3QueryMethods() { this in ["search"] }
    }

    private class LDAP3Query extends DataFlow::CallCfgNode, LDAPQuery::Range {
      DataFlow::Node ldapNode;

      LDAP3Query() {
        exists(DataFlow::AttrRead searchMethod, DataFlow::CallCfgNode connCall |
          this.getFunction() = searchMethod and
          connCall = API::moduleImport("ldap3").getMember("Connection").getACall() and
          connCall = searchMethod.getObject().getALocalSource() and
          searchMethod.getAttributeName() instanceof LDAP3QueryMethods and
          (
            ldapNode = this.getArg(0) or
            ldapNode = this.getArg(1)
          )
        )
      }

      override DataFlow::Node getLDAPNode() { result = ldapNode }
    }

    private class LDAP3EscapeDNCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP3EscapeDNCall() {
        this =
          API::moduleImport("ldap3")
              .getMember("utils")
              .getMember("dn")
              .getMember("escape_rdn")
              .getACall()
      }

      override DataFlow::Node getEscapeNode() { result = this.getArg(0) }
    }

    private class LDAP3EscapeFilterCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP3EscapeFilterCall() {
        this =
          API::moduleImport("ldap3")
              .getMember("utils")
              .getMember("conv")
              .getMember("escape_filter_chars")
              .getACall()
      }

      override DataFlow::Node getEscapeNode() { result = this.getArg(0) }
    }
  }
}
