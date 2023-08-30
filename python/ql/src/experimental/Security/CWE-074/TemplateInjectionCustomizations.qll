/**
 * Provides default sources, sinks and sanitizers for detecting
 * "template injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import TemplateConstructionConcept

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "template injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module TemplateInjection {
  /**
   * A data flow source for "template injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "template injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "template injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A SQL statement of a SQL construction, considered as a flow sink.
   */
  class TemplateConstructionAsSink extends Sink {
    TemplateConstructionAsSink() { this = any(TemplateConstruction c).getSourceArg() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier { }
}
