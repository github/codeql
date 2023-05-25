/**
 * Provides default sources, sinks and sanitizers for detecting
 * LDAP Injections, as well as extension points for adding your own
 */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.CFG

/**
 * Provides default sources, sinks and sanitizers for detecting
 * LDAP Injections, as well as extension points for adding your own
 */
module LdapInjection {
  /** A data flow source for LDAP Injection vulnerabilities */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for LDAP Injection vulnerabilities */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for LDAP Injection vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Additional taint steps for "LDAP Injection" vulnerabilities.
   */
  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(API::Node n, API::Node n2 |
      n = API::getTopLevelMember("Net").getMember("LDAP").getMember("Filter")
    |
      n2 = API::getTopLevelMember("Net").getMember("LDAP") and
      nodeTo = n2.getAMethodCall(["new"]).getAMethodCall(["search"]) and
      nodeFrom = n.getAMethodCall(["eq"]).getArgument([0, 1])
    )
  }

  /**
   * A source of remote user input, considered as a flow source.
   */
  private class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * An LDAP query execution considered as a flow sink.
   */
  private class LdapExecutionAsSink extends Sink {
    LdapExecutionAsSink() { this = any(LdapExecution l).getQuery() }
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
    StringConstArrayInclusionCallBarrier { }
}
