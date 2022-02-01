/**
 * Provides classes modeling security-relevant aspects of the `ldap3` PyPI package
 * See https://pypi.org/project/ldap3/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `ldap3` PyPI package
 *
 * See https://pypi.org/project/ldap3/
 */
private module Ldap3 {
  /** The execution of an `ldap` query. */
  private class LdapQueryExecution extends DataFlow::CallCfgNode, LDAP::LdapExecution::Range {
    LdapQueryExecution() {
      this =
        API::moduleImport("ldap3")
            .getMember("Connection")
            .getReturn()
            .getMember("search")
            .getACall()
    }

    override DataFlow::Node getFilter() {
      result in [this.getArg(1), this.getArgByName("search_filter")]
    }

    override DataFlow::Node getBaseDn() {
      result in [this.getArg(0), this.getArgByName("search_base")]
    }
  }

  /**
   * A call to `ldap3.utils.dn.escape_rdn`.
   *
   * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/dn.py#L390
   */
  private class LdapEscapeDnCall extends DataFlow::CallCfgNode, Escaping::Range {
    LdapEscapeDnCall() {
      this =
        API::moduleImport("ldap3")
            .getMember("utils")
            .getMember("dn")
            .getMember("escape_rdn")
            .getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("rdn")] }

    override DataFlow::Node getOutput() { result = this }

    override string getKind() { result = Escaping::getLdapDnKind() }
  }

  /**
   * A call to `ldap3.utils.conv.escape_filter_chars`.
   *
   * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/conv.py#L91
   */
  private class LdapEscapeFilterCall extends DataFlow::CallCfgNode, Escaping::Range {
    LdapEscapeFilterCall() {
      this =
        API::moduleImport("ldap3")
            .getMember("utils")
            .getMember("conv")
            .getMember("escape_filter_chars")
            .getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("text")] }

    override DataFlow::Node getOutput() { result = this }

    override string getKind() { result = Escaping::getLdapFilterKind() }
  }
}
