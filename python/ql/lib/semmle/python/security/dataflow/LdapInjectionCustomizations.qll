/**
 * Provides default sources, sinks and sanitizers for detecting
 * "ldap injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "ldap injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module LdapInjection {
  /**
   * A data flow source for "ldap injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "ldap injection" vulnerabilities.
   */
  abstract class DnSink extends DataFlow::Node { }

  /**
   * A data flow sink for "ldap injection" vulnerabilities.
   */
  abstract class FilterSink extends DataFlow::Node { }

  /**
   * A sanitizer for "ldap injection" vulnerabilities.
   */
  abstract class DnSanitizer extends DataFlow::Node { }

  /**
   * A sanitizer for "ldap injection" vulnerabilities.
   */
  abstract class FilterSanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "ldap injection" vulnerabilities.
   */
  abstract class DnSanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A sanitizer guard for "ldap injection" vulnerabilities.
   */
  abstract class FilterSanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A logging operation, considered as a flow sink.
   */
  class LdapExecutionAsDnSink extends DnSink {
    LdapExecutionAsDnSink() { this = any(LDAP::LdapExecution ldap).getBaseDn() }
  }

  /**
   * A logging operation, considered as a flow sink.
   */
  class LdapExecutionAsFilterSink extends FilterSink {
    LdapExecutionAsFilterSink() { this = any(LDAP::LdapExecution ldap).getFilter() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsDnSanitizerGuard extends DnSanitizerGuard, StringConstCompare { }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsFilterSanitizerGuard extends FilterSanitizerGuard, StringConstCompare {
  }

  /**
   * A call to replace line breaks functions as a sanitizer.
   */
  class LdapDnEscapingSanitizer extends DnSanitizer, DataFlow::CallCfgNode {
    LdapDnEscapingSanitizer() { this = any(LdapDnEscaping ldapDnEsc).getOutput() }
  }

  /**
   * A call to replace line breaks functions as a sanitizer.
   */
  class LdapFilterEscapingSanitizer extends FilterSanitizer, DataFlow::CallCfgNode {
    LdapFilterEscapingSanitizer() { this = any(LdapFilterEscaping ldapDnEsc).getOutput() }
  }
}
