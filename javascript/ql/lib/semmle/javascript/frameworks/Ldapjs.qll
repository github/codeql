/**
 * Provides classes for working with [ldapjs](https://github.com/ldapjs/node-ldapjs) (Client only)
 */

import javascript

module Ldapjs {
  /**
   * Gets a data flow source node for the ldapjs library.
   */
  private API::Node ldapjs() { result = API::moduleImport("ldapjs") } // TODO: createServer, parseDN.

  /**
   * Gets an LDAP client.
   */
  private API::Node ldapClient() { result = ldapjs().getMember("createClient").getReturn() }

  /**
   * A call to the ldapjs Client API methods.
   */
  class LdapjsClientAPICall extends API::CallNode {
    string methodName;

    LdapjsClientAPICall() {
      methodName = ["add", "bind", "compare", "del", "modify", "modifyDN", "search"] and
      this = ldapClient().getMember(methodName).getACall()
    }

    string getMethodName() { result = methodName }
  }

  /**
   * Gets a data flow node for the client `search` options.
   */
  class LdapjsSearchOptions extends API::Node {
    LdapjsClientAPICall queryCall;

    LdapjsSearchOptions() {
      queryCall.getMethodName() = "search" and
      this = queryCall.getParameter(1)
    }

    /**
     * Gets the LDAP query call that these options are used in.
     */
    API::CallNode getQueryCall() { result = queryCall }
  }

  /**
   * A distinguished name (DN) used in a Client API call against the LDAP server.
   */
  class LdapjsDNArgument extends DataFlow::Node {
    LdapjsClientAPICall queryCall;

    LdapjsDNArgument() { this = queryCall.getArgument(0) }

    /**
     * Gets the LDAP query call that this DN is used in.
     */
    API::CallNode getQueryCall() { result = queryCall }
  }

  /**
   * A creation of an Ldap filter that doesn't sanitizes the input.
   */
  abstract class LdapFilter extends DataFlow::Node {
    /**
     * The input that creates (part of) an Ldap filter.
     */
    abstract DataFlow::Node getInput();

    /**
     * The resulting Ldap filter.
     */
    abstract DataFlow::Node getOutput();
  }

  /**
   * Ldapjs parseFilter method call.
   */
  private class LdapjsParseFilter extends LdapFilter, API::CallNode {
    LdapjsParseFilter() { this = ldapjs().getMember("parseFilter").getACall() }

    override DataFlow::Node getInput() { result = this.getArgument(0) }

    override DataFlow::Node getOutput() { result = this }
  }

  /**
   * A filter used in call to "search" on an LDAP client.
   * We model that as a step from the ".filter" write to the options object itself.
   */
  class LdapjsSearchFilter extends LdapFilter {
    LdapjsSearchOptions options;

    LdapjsSearchFilter() {
      options = ldapClient().getMember("search").getACall().getParameter(1) and
      this = options.getARhs()
    }

    override DataFlow::Node getInput() { result = options.getMember("filter").getARhs() }

    override DataFlow::Node getOutput() { result = this }
  }
}
