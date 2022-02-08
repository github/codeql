import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.BarrierGuards

module XmlInjection {
  import XmlInjectionCustomizations::XmlInjection

  class XMLInjectionConfiguration extends TaintTracking::Configuration {
    XMLInjectionConfiguration() { this = "XMLInjectionConfiguration" }

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
  predicate xmlInjection(DataFlow::PathNode source, DataFlow::PathNode sink) {
    any(XMLInjectionConfiguration xmlInjectionConfig).hasFlowPath(source, sink)
  }

  /** Holds if there is an XML injection from `source` to `sink` vulnerable to `kind` */
  predicate xmlInjectionVulnerable(DataFlow::PathNode source, DataFlow::PathNode sink, string kind) {
    xmlInjection(source, sink) and
    (
      xmlParsingInputAsVulnerableSink(sink.getNode(), kind) or
      xmlParserInputAsVulnerableSink(sink.getNode(), kind)
    )
  }
}
