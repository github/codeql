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
private module Ldap {
  /**
   * Provides models for the `python-ldap` PyPI package (imported as `ldap`).
   *
   * See https://www.python-ldap.org/en/python-ldap-3.3.0/index.html
   */
  private module Ldap2 {
    /** Gets a reference to the `ldap` module. */
    API::Node ldap() { result = API::moduleImport("ldap") }

    /** Returns a `ldap` module instance */
    API::Node ldapInitialize() { result = ldap().getMember("initialize") }

    /** Gets a reference to a `ldap` operation. */
    private API::Node ldapOperation(string name) {
      result = ldapInitialize().getReturn().getMember(name)
    }

    /**
     * List of `ldap` methods used to execute a query.
     *
     * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap.html#functions
     */
    private class Ldap2QueryMethods extends string {
      Ldap2QueryMethods() {
        this in ["search", "search_s", "search_st", "search_ext", "search_ext_s"]
      }
    }

    /**
     * A class to find `ldap` methods executing a query.
     *
     * See `LDAP2QueryMethods`
     */
    private class Ldap2Query extends DataFlow::CallCfgNode, LdapQuery::Range {
      Ldap2Query() { this = ldapOperation(any(Ldap2QueryMethods m)).getACall() }

      override DataFlow::Node getQuery() {
        result in [this.getArg(0), this.getArg(2), this.getArgByName("filterstr")]
      }
    }

    /**
     * List of `ldap` methods used for binding.
     *
     * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap.html#functions
     */
    private class Ldap2BindMethods extends string {
      Ldap2BindMethods() {
        this in [
            "bind", "bind_s", "simple_bind", "simple_bind_s", "sasl_interactive_bind_s",
            "sasl_non_interactive_bind_s", "sasl_external_bind_s", "sasl_gssapi_bind_s"
          ]
      }
    }

    /**List of SSL-demanding options */
    private class LdapSslOptions extends DataFlow::Node {
      LdapSslOptions() {
        this = ldap().getMember("OPT_X_TLS_" + ["DEMAND", "HARD"]).getAValueReachableFromSource()
      }
    }

    /**
     * A class to find `ldap` methods binding a connection.
     *
     * See `LDAP2BindMethods`
     */
    private class Ldap2Bind extends DataFlow::CallCfgNode, LdapBind::Range {
      Ldap2Bind() { this = ldapOperation(any(Ldap2BindMethods m)).getACall() }

      override DataFlow::Node getPassword() {
        result in [this.getArg(1), this.getArgByName("cred")]
      }

      override DataFlow::Node getHost() {
        exists(DataFlow::CallCfgNode initialize |
          this.getFunction().(DataFlow::AttrRead).getObject().getALocalSource() = initialize and
          initialize = ldapInitialize().getACall() and
          result = initialize.getArg(0)
        )
      }

      override predicate useSsl() {
        // use initialize to correlate `this` and so avoid FP in several instances
        exists(DataFlow::CallCfgNode initialize |
          // ldap.set_option(ldap.OPT_X_TLS_%s)
          ldap().getMember("set_option").getACall().getArg(_) instanceof LdapSslOptions
          or
          this.getFunction().(DataFlow::AttrRead).getObject().getALocalSource() = initialize and
          initialize = ldapInitialize().getACall() and
          (
            // ldap_connection.start_tls_s()
            // see https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap.html#ldap.LDAPObject.start_tls_s
            exists(DataFlow::MethodCallNode startTls |
              startTls.getObject().getALocalSource() = initialize and
              startTls.getMethodName() = "start_tls_s"
            )
            or
            // ldap_connection.set_option(ldap.OPT_X_TLS_%s, True)
            exists(DataFlow::CallCfgNode setOption |
              setOption.getFunction().(DataFlow::AttrRead).getObject().getALocalSource() =
                initialize and
              setOption.getFunction().(DataFlow::AttrRead).getAttributeName() = "set_option" and
              setOption.getArg(0) instanceof LdapSslOptions and
              not DataFlow::exprNode(any(False falseExpr))
                  .(DataFlow::LocalSourceNode)
                  .flowsTo(setOption.getArg(1))
            )
          )
        )
      }
    }

    /**
     * A class to find calls to `ldap.dn.escape_dn_chars`.
     *
     * See https://github.com/python-ldap/python-ldap/blob/7ce471e238cdd9a4dd8d17baccd1c9e05e6f894a/Lib/ldap/dn.py#L17
     */
    private class Ldap2EscapeDNCall extends DataFlow::CallCfgNode, LdapEscape::Range {
      Ldap2EscapeDNCall() { this = ldap().getMember("dn").getMember("escape_dn_chars").getACall() }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }

    /**
     * A class to find calls to `ldap.filter.escape_filter_chars`.
     *
     * See https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap-filter.html#ldap.filter.escape_filter_chars
     */
    private class Ldap2EscapeFilterCall extends DataFlow::CallCfgNode, LdapEscape::Range {
      Ldap2EscapeFilterCall() {
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
  private module Ldap3 {
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
    private class Ldap3Query extends DataFlow::CallCfgNode, LdapQuery::Range {
      Ldap3Query() {
        this.getFunction().(DataFlow::AttrRead).getObject().getALocalSource() =
          ldap3Connection().getACall() and
        this.getFunction().(DataFlow::AttrRead).getAttributeName() = "search"
      }

      override DataFlow::Node getQuery() { result in [this.getArg(0), this.getArg(1)] }
    }

    /**
     * A class to find `ldap3` methods binding a connection.
     */
    class Ldap3Bind extends DataFlow::CallCfgNode, LdapBind::Range {
      Ldap3Bind() { this = ldap3Connection().getACall() }

      override DataFlow::Node getPassword() {
        result in [this.getArg(2), this.getArgByName("password")]
      }

      override DataFlow::Node getHost() {
        exists(DataFlow::CallCfgNode serverCall |
          serverCall = ldap3Server().getACall() and
          this.getArg(0).getALocalSource() = serverCall and
          result = serverCall.getArg(0)
        )
      }

      override predicate useSsl() {
        exists(DataFlow::CallCfgNode serverCall |
          serverCall = ldap3Server().getACall() and
          this.getArg(0).getALocalSource() = serverCall and
          DataFlow::exprNode(any(True trueExpr))
              .(DataFlow::LocalSourceNode)
              .flowsTo([serverCall.getArg(2), serverCall.getArgByName("use_ssl")])
        )
        or
        // ldap_connection.start_tls_s()
        // see https://www.python-ldap.org/en/python-ldap-3.3.0/reference/ldap.html#ldap.LDAPObject.start_tls_s
        exists(DataFlow::MethodCallNode startTls |
          startTls.getMethodName() = "start_tls_s" and
          startTls.getObject().getALocalSource() = this
        )
      }
    }

    /**
     * A class to find calls to `ldap3.utils.dn.escape_rdn`.
     *
     * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/dn.py#L390
     */
    private class Ldap3EscapeDNCall extends DataFlow::CallCfgNode, LdapEscape::Range {
      Ldap3EscapeDNCall() { this = ldap3Utils().getMember("dn").getMember("escape_rdn").getACall() }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }

    /**
     * A class to find calls to `ldap3.utils.conv.escape_filter_chars`.
     *
     * See https://github.com/cannatag/ldap3/blob/4d33166f0869b929f59c6e6825a1b9505eb99967/ldap3/utils/conv.py#L91
     */
    private class Ldap3EscapeFilterCall extends DataFlow::CallCfgNode, LdapEscape::Range {
      Ldap3EscapeFilterCall() {
        this = ldap3Utils().getMember("conv").getMember("escape_filter_chars").getACall()
      }

      override DataFlow::Node getAnInput() { result = this.getArg(0) }
    }
  }
}
