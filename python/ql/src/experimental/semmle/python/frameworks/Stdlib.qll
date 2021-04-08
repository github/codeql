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

/**
 * Provides models for Python's ldap-related libraries.
 */
private module LDAP {
  /**
   * Provides models for Python's `ldap` library.
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
     * A class to find `ldap` methods binding a connection.
     *
     * See `LDAP2QueryMethods`
     */
    class LDAP2Bind extends DataFlow::CallCfgNode, LDAPBind::Range {
      DataFlow::Node queryNode;

      LDAP2Bind() {
        exists(
          DataFlow::AttrRead bindMethod, DataFlow::CallCfgNode searchCall,
          DataFlow::AttrRead searchMethod
        |
          this.getFunction() = bindMethod and
          API::moduleImport("ldap").getMember("initialize").getACall() =
            bindMethod.getObject().getALocalSource() and
          bindMethod.getAttributeName().matches("%bind%") and
          searchCall.getFunction() = searchMethod and
          bindMethod.getObject().getALocalSource() = searchMethod.getObject().getALocalSource() and
          searchMethod.getAttributeName() instanceof LDAP2QueryMethods and
          (
            queryNode = searchCall.getArg(2) or
            queryNode = searchCall.getArgByName("filterstr")
          )
        )
      }

      override DataFlow::Node getPasswordNode() { result = this.getArg(1) }

      override DataFlow::Node getQueryNode() { result = queryNode }
    }
  }

  /**
   * Provides models for Python's `ldap3` library.
   *
   * See https://pypi.org/project/ldap3/
   */
  private module LDAP3 {
    /**
     * A class to find `ldap3` methods binding a connection.
     */
    class LDAP3Bind extends DataFlow::CallCfgNode, LDAPBind::Range {
      DataFlow::Node queryNode;

      LDAP3Bind() {
        exists(DataFlow::CallCfgNode searchCall, DataFlow::AttrRead searchMethod |
          this = API::moduleImport("ldap3").getMember("Connection").getACall() and
          searchMethod.getObject().getALocalSource() = this and
          searchCall.getFunction() = searchMethod and
          searchMethod.getAttributeName() = "search" and
          queryNode = searchCall.getArg(1)
        )
      }

      override DataFlow::Node getPasswordNode() { result = this.getArgByName("password") }

      override DataFlow::Node getQueryNode() { result = queryNode }
    }
  }
}
