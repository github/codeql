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
    LdapjsSearchOptions() {
      this = any(LdapClient client).getAMemberCall("search").getArgument(1).getALocalSource()
    }
  }

  /**
   * A filter used in a `search` operation against the LDAP server.
   */
  class LdapjsSearchFilter extends DataFlow::Node {
    LdapjsSearchFilter() {
      this = any(LdapjsSearchOptions options).getAPropertyWrite("filter").getRhs()
    }
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
    LdapjsDNArgument() { this = any(LdapjsClientAPICall clientAPIcall).getArgument(0) }
  }

  /**
   * Ldapjs parseFilter method call.
   */
  class LdapjsParseFilter extends DataFlow::CallNode {
    LdapjsParseFilter() { this = ldapjs().getAMemberCall("parseFilter") }
  }
}
