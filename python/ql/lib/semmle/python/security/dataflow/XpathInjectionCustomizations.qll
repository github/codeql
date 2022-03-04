/**
 * Provides class and predicates to track external data that
 * may represent malicious xpath query objects.
 *
 * This module is intended to be imported into a taint-tracking query.
 */

private import python
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/** Models Xpath Injection related classes and functions */
module XpathInjection {
  /**
   * A data flow source for "XPath injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "XPath injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "XPath injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "XPath injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A construction of an XPath expression, considered as a sink.
   */
  class XPathConstructionArg extends Sink {
    XPathConstructionArg() { this = any(XML::XPathConstruction c).getXPath() }
  }

  /**
   * An execution of an XPath expression, considered as a sink.
   */
  class XPathExecutionArg extends Sink {
    XPathExecutionArg() { this = any(XML::XPathExecution e).getXPath() }
  }
}
