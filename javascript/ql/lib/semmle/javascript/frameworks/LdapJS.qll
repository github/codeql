/**
 * Provides classes for working with [LDAPjs](https://www.npmjs.com/package/ldapjs)
 */

import javascript

/**
 * A module providing sinks and sanitizers for LDAP injection.
 */
module LdapJS {
  /** Gets a reference to the ldapjs library. */
  API::Node ldapjs() { result = API::moduleImport("ldapjs") }

  /** Gets an LDAPjs client. */
  private API::Node ldapClient() { result = ldapjs().getMember("createClient").getReturn() }

  /** A call to a LDAPjs Client API method. */
  class ClientCall extends API::CallNode {
    string methodName;

    ClientCall() {
      methodName = ["add", "bind", "compare", "del", "modify", "modifyDN", "search"] and
      this = ldapClient().getMember(methodName).getACall()
    }

    /** Gets the name of the LDAPjs Client API method. */
    string getMethodName() { result = methodName }
  }

  /** A reference to a LDAPjs client `search` options. */
  class SearchOptions extends API::Node {
    SearchOptions() {
      exists(ClientCall call | call.getMethodName() = "search" and this = call.getParameter(1))
    }
  }

  /** A creation of an LDAPjs filter, or object containing a filter, that doesn't sanitizes the input. */
  abstract class TaintPreservingLdapFilterStep extends DataFlow::Node {
    /** Gets the input that creates (part of) an LDAPjs filter. */
    abstract DataFlow::Node getInput();

    /** Gets the resulting LDAPjs filter. */
    abstract DataFlow::Node getOutput();
  }

  /** A call to the LDAPjs utility method "parseFilter". */
  private class ParseFilter extends TaintPreservingLdapFilterStep, API::CallNode {
    ParseFilter() { this = ldapjs().getMember("parseFilter").getACall() }

    override DataFlow::Node getInput() { result = this.getArgument(0) }

    override DataFlow::Node getOutput() { result = this }
  }

  /**
   * A filter used in call to "search" on an LDAPjs client.
   * We model that as a step from the ".filter" write to the options object itself.
   */
  private class SearchFilter extends TaintPreservingLdapFilterStep {
    SearchOptions options;

    SearchFilter() {
      options = ldapClient().getMember("search").getACall().getParameter(1) and
      this = options.getARhs()
    }

    override DataFlow::Node getInput() { result = options.getMember("filter").getARhs() }

    override DataFlow::Node getOutput() { result = this }
  }
}
