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
  abstract class LdapClient extends DataFlow::SourceNode { }

  /**
   * Gets a data flow source node for the ldapjs library.
   */
  private DataFlow::SourceNode ldapjs() { result = DataFlow::moduleImport("ldapjs") }

  /**
   * Gets a data flow source node for the ldapjs client.
   */
  class LdapjsClient extends LdapClient {
    LdapjsClient() { this = ldapjs().getAMemberCall("createClient") }
  }

  /**
   * Gets a data flow node for the client `search` options.
   */
  class LdapjsSearchOptions extends DataFlow::SourceNode {
    DataFlow::CallNode queryCall;

    LdapjsSearchOptions() {
      queryCall = any(LdapjsClient client).getAMemberCall("search") and
      this = queryCall.getArgument(1).getALocalSource()
    }

    /**
     * Gets the LDAP query call that these options are used in.
     */
    DataFlow::InvokeNode getQueryCall() { result = queryCall }
  }

  /**
   * A filter used in a `search` operation against the LDAP server.
   */
  class LdapjsSearchFilter extends DataFlow::Node {
    LdapjsSearchOptions options;

    LdapjsSearchFilter() { this = options.getAPropertyWrite("filter").getRhs() }

    /**
     * Gets the LDAP query call that this filter is used in.
     */
    DataFlow::InvokeNode getQueryCall() { result = options.getQueryCall() }
  }

  /**
   * A call to the ldapjs Client API methods.
   */
  class LdapjsClientAPICall extends DataFlow::CallNode {
    LdapjsClientAPICall() {
      this = any(LdapjsClient client).getAMemberCall(getLdapjsClientDNMethodName())
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
    DataFlow::InvokeNode getQueryCall() { result = queryCall }
  }

  /**
   * Ldapjs parseFilter method call.
   */
  class LdapjsParseFilter extends DataFlow::CallNode {
    LdapjsParseFilter() { this = ldapjs().getAMemberCall("parseFilter") }
  }
}
