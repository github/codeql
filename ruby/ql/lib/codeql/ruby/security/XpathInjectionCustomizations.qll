/**
 * Provides class and predicates to track external data that
 * may represent malicious xpath query objects.
 *
 * This module is intended to be imported into a taint-tracking query.
 */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.RemoteFlowSources

/** Models Xpath Injection related classes and functions */
module XpathInjection {
  /** A data flow source for "XPath injection" vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for "XPath injection" vulnerabilities */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for "XPath injection" vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  private class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * An execution of an XPath expression, considered as a sink.
   */
  private class XPathExecutionAsSink extends Sink {
    XPathExecutionAsSink() { this = any(XPathExecution e).getXPath() }
  }

  /**
   * A construction of an XPath expression, considered as a sink.
   */
  private class XPathConstructionAsSink extends Sink {
    XPathConstructionAsSink() { this = any(XPathConstruction c).getXPath() }
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
