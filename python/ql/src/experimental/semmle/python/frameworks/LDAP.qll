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
    /** Gets a reference to the `ldap` module. */
    API::Node ldap() { result = API::moduleImport("ldap") }

    /** Returns a `ldap` module instance */
    API::Node ldapInitialize() { result = ldap().getMember("initialize") }

    /** Gets a reference to a `ldap` operation. */
    private DataFlow::LocalSourceNode ldapOperation(DataFlow::TypeTracker t) {
      t.start() and
      result.(DataFlow::AttrRead).getObject().getALocalSource() = ldapInitialize().getACall()
      or
      exists(DataFlow::TypeTracker t2 | result = ldapOperation(t2).track(t2, t))
    }

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

    /** Gets a reference to a `ldap` operation. */
    private DataFlow::Node ldapOperation() {
      ldapOperation(DataFlow::TypeTracker::end()).flowsTo(result)
    }

    /** Gets a reference to a `ldap` query. */
    private DataFlow::Node ldapQuery() {
      result = ldapOperation() and
      result.(DataFlow::AttrRead).getAttributeName() instanceof LDAP2QueryMethods
    }

    /**
     * A class to find `ldap` methods executing a query.
     *
     * See `LDAP2QueryMethods`
     */
    private class LDAP2Query extends DataFlow::CallCfgNode, LDAPQuery::Range {
      LDAP2Query() { this.getFunction() = ldapQuery() }

      override DataFlow::Node getQuery() {
        result in [this.getArg(0), this.getArg(2), this.getArgByName("filterstr")]
      }
    }

    /**
     * List of `ldap` methods used for binding.
     *
     * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap.html#functions
     */
    private class LDAP2BindMethods extends string {
      LDAP2BindMethods() {
        this in [
            "bind", "bind_s", "simple_bind", "simple_bind_s", "sasl_interactive_bind_s",
            "sasl_non_interactive_bind_s", "sasl_external_bind_s", "sasl_gssapi_bind_s"
          ]
      }
    }

    /** Gets a reference to a `ldap` bind. */
    private DataFlow::Node ldapBind() {
      result = ldapOperation() and
      result.(DataFlow::AttrRead).getAttributeName() instanceof LDAP2BindMethods
    }

    /**
     * A class to find `ldap` methods binding a connection.
     *
     * See `LDAP2BindMethods`
     */
    private class LDAP2Bind extends DataFlow::CallCfgNode, LDAPBind::Range {
      LDAP2Bind() { this.getFunction() = ldapBind() }

      override DataFlow::Node getPassword() {
        result in [this.getArg(1), this.getArgByName("cred")]
      }
    }

    /**
     * A class to find calls to `ldap.dn.escape_dn_chars`.
     *
     * See https://github.com/python-ldap/python-ldap/blob/7ce471e238cdd9a4dd8d17baccd1c9e05e6f894a/Lib/ldap/dn.py#L17
     */
    private class LDAP2EscapeDNCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP2EscapeDNCall() { this = ldap().getMember("dn").getMember("escape_dn_chars").getACall() }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }

    /**
     * A class to find calls to `ldap.filter.escape_filter_chars`.
     *
     * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap-filter.html#ldap.filter.escape_filter_chars
     */
    private class LDAP2EscapeFilterCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP2EscapeFilterCall() {
        this = ldap().getMember("filter").getMember("escape_filter_chars").getACall()
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
    /** Gets a reference to the `ldap3` module. */
    API::Node ldap3() { result = API::moduleImport("ldap3") }

    /** Gets a reference to the `ldap3` `utils` module. */
    API::Node ldap3Utils() { result = ldap3().getMember("utils") }

    /** Returns a `ldap3` module `Server` instance */
    API::Node ldap3Server() { result = ldap3().getMember("Server") }

    /** Returns a `ldap3` module `Connection` instance */
    API::Node ldap3Connection() { result = ldap3().getMember("Connection") }

    /**
     * A class to find `ldap3` methods executing a query.
     */
    private class LDAP3Query extends DataFlow::CallCfgNode, LDAPQuery::Range {
      LDAP3Query() {
        this.getFunction().(DataFlow::AttrRead).getObject().getALocalSource() =
          ldap3Connection().getACall() and
        this.getFunction().(DataFlow::AttrRead).getAttributeName() = "search"
      }

      override DataFlow::Node getQuery() { result in [this.getArg(0), this.getArg(1)] }
    }

    /**
     * A class to find `ldap3` methods binding a connection.
     */
    class LDAP3Bind extends DataFlow::CallCfgNode, LDAPBind::Range {
      LDAP3Bind() { this = ldap3Connection().getACall() }

      override DataFlow::Node getPassword() {
        result in [this.getArg(2), this.getArgByName("password")]
      }
    }

    /**
     * A class to find calls to `ldap3.utils.dn.escape_rdn`.
     *
     * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/dn.py#L390
     */
    private class LDAP3EscapeDNCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP3EscapeDNCall() { this = ldap3Utils().getMember("dn").getMember("escape_rdn").getACall() }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }

    /**
     * A class to find calls to `ldap3.utils.conv.escape_filter_chars`.
     *
     * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/conv.py#L91
     */
    private class LDAP3EscapeFilterCall extends DataFlow::CallCfgNode, LDAPEscape::Range {
      LDAP3EscapeFilterCall() {
        this = ldap3Utils().getMember("conv").getMember("escape_filter_chars").getACall()
      }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }
  }
}
