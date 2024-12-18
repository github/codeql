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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

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
