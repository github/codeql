import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.BarrierGuards

module XmlEntityInjection {
  import XmlEntityInjectionCustomizations::XmlEntityInjection

  class XmlEntityInjectionConfiguration extends TaintTracking::Configuration {
    XmlEntityInjectionConfiguration() { this = "XmlEntityInjectionConfiguration" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof RemoteFlowSourceAsSource
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }

    override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      ioAdditionalTaintStep(nodeFrom, nodeTo)
    }
  }

  private import DataFlow::PathGraph

  /** Holds if there is an XML injection from `source` to `sink` */
  predicate xmlEntityInjection(DataFlow::PathNode source, DataFlow::PathNode sink) {
    any(XmlEntityInjectionConfiguration x).hasFlowPath(source, sink)
  }

  /** Holds if there is an XML injection from `source` to `sink` vulnerable to `kind` */
  predicate xmlEntityInjectionVulnerable(
    DataFlow::PathNode source, DataFlow::PathNode sink, string kind
  ) {
    xmlEntityInjection(source, sink) and
    (
      xmlParsingInputAsVulnerableSink(sink.getNode(), kind) or
      xmlParserInputAsVulnerableSink(sink.getNode(), kind)
    )
  }
}
