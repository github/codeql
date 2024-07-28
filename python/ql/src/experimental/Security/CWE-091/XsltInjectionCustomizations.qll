/**
 * Provides default sources, sinks and sanitizers for detecting
 * "XSLT injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import XsltConcept

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "XSLT injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module XsltInjection {
  /**
   * A data flow source for "XSLT injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "XSLT injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "XSLT injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * An XSLT construction, considered as a flow sink.
   */
  class XsltConstructionAsSink extends Sink {
    XsltConstructionAsSink() { this = any(XsltConstruction c).getXsltArg() }
  }

  /**
   * An XSLT execution, considered as a flow sink.
   */
  class XsltExecutionAsSink extends Sink {
    XsltExecutionAsSink() { this = any(XsltExecution c).getXsltArg() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier { }
}
