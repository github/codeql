/**
 * Provides classes for working with [ldapjs](https://github.com/ldapjs/node-ldapjs) (Client only)
 */

import javascript

module Ldapjs {
  /**
   * Gets a method name on an LDAPjs client that accepts a DN as the first argument.
   */
  private string getLdapjsClientDNMethodName() {
    result = ["add", "bind", "compare", "del", "modify", "modifyDN", "search"]
  }

  /**
   * Gets a data flow source node for an LDAP client.
   */
  abstract class LdapClient extends API::Node { }

  /**
   * Gets a data flow source node for the ldapjs library.
   */
  private API::Node ldapjs() { result = API::moduleImport("ldapjs") }

  /**
   * Gets a data flow source node for the ldapjs client.
   */
  class LdapjsClient extends LdapClient {
    LdapjsClient() { this = ldapjs().getMember("createClient").getReturn() }
  }

  /**
   * Gets a data flow node for the client `search` options.
   */
  class LdapjsSearchOptions extends API::Node {
    API::CallNode queryCall;

    LdapjsSearchOptions() {
      queryCall = any(LdapjsClient client).getMember("search").getACall() and
      this = queryCall.getParameter(1)
    }

    /**
     * Gets the LDAP query call that these options are used in.
     */
    API::CallNode getQueryCall() { result = queryCall }
  }

  /**
   * A filter used in a `search` operation against the LDAP server.
   */
  class LdapjsSearchFilter extends DataFlow::Node {
    LdapjsSearchOptions options;

    LdapjsSearchFilter() { this = options.getMember("filter").getARhs() }

    /**
     * Gets the LDAP query call that this filter is used in.
     */
    API::CallNode getQueryCall() { result = options.getQueryCall() }
  }

  /**
   * A call to the ldapjs Client API methods.
   */
  class LdapjsClientAPICall extends API::CallNode {
    LdapjsClientAPICall() {
      this = any(LdapjsClient client).getMember(getLdapjsClientDNMethodName()).getACall()
    }
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
   * Ldapjs parseFilter method call.
   */
  class LdapjsParseFilter extends DataFlow::CallNode {
    LdapjsParseFilter() { this = ldapjs().getMember("parseFilter").getACall() }
  }
}
