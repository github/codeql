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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A logging operation, considered as a flow sink.
   */
  class LdapExecutionAsDnSink extends DnSink {
    LdapExecutionAsDnSink() { this = any(Ldap::LdapExecution ldap).getBaseDn() }
  }

  /**
   * A logging operation, considered as a flow sink.
   */
  class LdapExecutionAsFilterSink extends FilterSink {
    LdapExecutionAsFilterSink() { this = any(Ldap::LdapExecution ldap).getFilter() }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsDnSanitizerGuard extends DnSanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsDnSanitizerGuard instead. */
  deprecated class StringConstCompareAsSanitizerGuard = ConstCompareAsDnSanitizerGuard;

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsFilterSanitizerGuard extends FilterSanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsFilterSanitizerGuard instead. */
  deprecated class StringConstCompareAsFilterSanitizerGuard = ConstCompareAsFilterSanitizerGuard;

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
