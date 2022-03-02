/**
 * Provides classes modeling security-relevant aspects of the `python-ldap` PyPI package (imported as `ldap`).
 * See https://www.python-ldap.org/en/python-ldap-3.3.0/index.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `python-ldap` PyPI package (imported as `ldap`).
 *
 * See https://www.python-ldap.org/en/python-ldap-3.3.0/index.html
 */
private module Ldap {
  /**
   * The execution of an `ldap` query.
   *
   * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap.html#functions
   */
  private class LdapQueryExecution extends DataFlow::CallCfgNode, LDAP::LdapExecution::Range {
    LdapQueryExecution() {
      this =
        API::moduleImport("ldap")
            .getMember("initialize")
            .getReturn()
            .getMember(["search", "search_s", "search_st", "search_ext", "search_ext_s"])
            .getACall()
    }

    override DataFlow::Node getFilter() {
      result in [this.getArg(2), this.getArgByName("filterstr")]
    }

    override DataFlow::Node getBaseDn() { result in [this.getArg(0), this.getArgByName("base")] }
  }

  /**
   * A call to `ldap.dn.escape_dn_chars`.
   *
   * See https://github.com/python-ldap/python-ldap/blob/7ce471e238cdd9a4dd8d17baccd1c9e05e6f894a/Lib/ldap/dn.py#L17
   */
  private class LdapEscapeDnCall extends DataFlow::CallCfgNode, Escaping::Range {
    LdapEscapeDnCall() {
      this = API::moduleImport("ldap").getMember("dn").getMember("escape_dn_chars").getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("s")] }

    override DataFlow::Node getOutput() { result = this }

    override string getKind() { result = Escaping::getLdapDnKind() }
  }

  /**
   * A call to `ldap.filter.escape_filter_chars`.
   *
   * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap-filter.html#ldap.filter.escape_filter_chars
   */
  private class LdapEscapeFilterCall extends DataFlow::CallCfgNode, Escaping::Range {
    LdapEscapeFilterCall() {
      this =
        API::moduleImport("ldap").getMember("filter").getMember("escape_filter_chars").getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("assertion_value")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getKind() { result = Escaping::getLdapFilterKind() }
  }
}
