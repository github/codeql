/**
 * Provides default sources, sinks and sanitizers for detecting
 * improper LDAP authentication, as well as extension points for adding your own
 */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.RemoteFlowSources

/**
 * Provides default sources, sinks and sanitizers for detecting
 * improper LDAP authentication,  as well as extension points for adding your own
 */
module ImproperLdapAuth {
  /** A data flow source for improper LDAP authentication vulnerabilities */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for improper LDAP authentication vulnerabilities */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for improper LDAP authentication vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  private class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * An LDAP query execution considered as a flow sink.
   */
  private class LdapBindAsSink extends Sink {
    LdapBindAsSink() { this = any(LdapBind l).getPassword() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  private class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier { }

  /**
   * An inclusion check against an array of constant strings, considered as a
   * sanitizer-guard.
   */
  private class StringConstArrayInclusionCallAsSanitizer extends Sanitizer,
    StringConstArrayInclusionCallBarrier
  { }
}
