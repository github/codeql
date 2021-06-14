/**
 * Provides classes modeling security-relevant aspects of the LDAP libraries.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for Python's ldap-related libraries.
 */
private module LDAP {
  /**
   * Provides models for the `python-ldap` PyPI package (imported as `ldap`).
   *
   * See https://www.python-ldap.org/en/python-ldap-3.3.0/index.html
   */
  private module LDAP2 {
    /**
     * List of `ldap` methods used to execute a query.
     *
     * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap.html#functions
     */
    private class LDAP2QueryMethods extends string {
      LDAP2QueryMethods() {
        this in ["search", "search_s", "search_st", "search_ext", "search_ext_s"]
      }
    }

    /**
     * A class to find `ldap` methods executing a query.
     *
     * See `LDAP2QueryMethods`
     */
    private class LDAP2Query extends DataFlow::CallCfgNode, LDAPQuery::Range {
      DataFlow::Node ldapQuery;

      LDAP2Query() {
        exists(DataFlow::AttrRead searchMethod |
          this.getFunction() = searchMethod and
          API::moduleImport("ldap").getMember("initialize").getACall() =
            searchMethod.getObject().getALocalSource() and
          searchMethod.getAttributeName() instanceof LDAP2QueryMethods and
          (
            ldapQuery = this.getArg(0)
            or
            (
              ldapQuery = this.getArg(2) or
              ldapQuery = this.getArgByName("filterstr")
            )
          )
        )
      }

      override DataFlow::Node getQuery() { result = ldapQuery }
    }

    /**
     * A class to find calls to `ldap.dn.escape_dn_chars`.
     *
     * See https://github.com/python-ldap/python-ldap/blob/7ce471e238cdd9a4dd8d17baccd1c9e05e6f894a/Lib/ldap/dn.py#L17
     */
    private class LDAP2EscapeDNCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP2EscapeDNCall() {
        this = API::moduleImport("ldap").getMember("dn").getMember("escape_dn_chars").getACall()
      }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }

    /**
     * A class to find calls to `ldap.filter.escape_filter_chars`.
     *
     * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap-filter.html#ldap.filter.escape_filter_chars
     */
    private class LDAP2EscapeFilterCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP2EscapeFilterCall() {
        this =
          API::moduleImport("ldap").getMember("filter").getMember("escape_filter_chars").getACall()
      }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }
  }

  /**
   * Provides models for the `ldap3` PyPI package
   *
   * See https://pypi.org/project/ldap3/
   */
  private module LDAP3 {
    /**
     * A class to find `ldap3` methods executing a query.
     */
    private class LDAP3Query extends DataFlow::CallCfgNode, LDAPQuery::Range {
      DataFlow::Node ldapQuery;

      LDAP3Query() {
        exists(DataFlow::AttrRead searchMethod |
          this.getFunction() = searchMethod and
          API::moduleImport("ldap3").getMember("Connection").getACall() =
            searchMethod.getObject().getALocalSource() and
          searchMethod.getAttributeName() = "search" and
          (
            ldapQuery = this.getArg(0) or
            ldapQuery = this.getArg(1)
          )
        )
      }

      override DataFlow::Node getQuery() { result = ldapQuery }
    }

    /**
     * A class to find calls to `ldap3.utils.dn.escape_rdn`.
     *
     * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/dn.py#L390
     */
    private class LDAP3EscapeDNCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP3EscapeDNCall() {
        this =
          API::moduleImport("ldap3")
              .getMember("utils")
              .getMember("dn")
              .getMember("escape_rdn")
              .getACall()
      }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }

    /**
     * A class to find calls to `ldap3.utils.conv.escape_filter_chars`.
     *
     * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/conv.py#L91
     */
    private class LDAP3EscapeFilterCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP3EscapeFilterCall() {
        this =
          API::moduleImport("ldap3")
              .getMember("utils")
              .getMember("conv")
              .getMember("escape_filter_chars")
              .getACall()
      }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }
  }
}
