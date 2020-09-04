/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * LDAP injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
import Ldapjs::Ldapjs

module LdapInjection {
  /**
   * A data flow source for LDAP injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for LDAP injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the LDAP query call that the sink flows into.
     */
    abstract DataFlow::Node getQueryCall();
  }

  /**
   * A sanitizer for LDAP injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source for LDAP injection.
   */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An LDAP filter for an API call that executes an operation against the LDAP server.
   */
  class LdapjsSearchFilterAsSink extends Sink {
    LdapjsSearchFilterAsSink() { this instanceof LdapjsSearchFilter }

    override DataFlow::InvokeNode getQueryCall() {
      result = this.(LdapjsSearchFilter).getQueryCall()
    }
  }

  /**
   * An LDAP DN argument for an API call that executes an operation against the LDAP server.
   */
  class LdapjsDNArgumentAsSink extends Sink {
    LdapjsDNArgumentAsSink() { this instanceof LdapjsDNArgument }

    override DataFlow::InvokeNode getQueryCall() { result = this.(LdapjsDNArgument).getQueryCall() }
  }

  /**
   * A call to a function whose name suggests that it escapes LDAP search query parameter.
   */
  class FilterOrDNSanitizationCall extends Sanitizer, DataFlow::CallNode {
    FilterOrDNSanitizationCall() {
      exists(string sanitize, string input |
        sanitize = "(?:escape|saniti[sz]e|validate|filter)" and
        input = "[Ii]nput?"
      |
        this
            .getCalleeName()
            .regexpMatch("(?i)(" + sanitize + input + ")" + "|(" + input + sanitize + ")")
      )
    }
  }

  /**
   * A step through the parseFilter API (https://github.com/ldapjs/node-ldapjs/issues/181).
   */
  class StepThroughParseFilter extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    StepThroughParseFilter() { this instanceof LdapjsParseFilter }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = this.getArgument(0) and
      succ = this
    }
  }
}
