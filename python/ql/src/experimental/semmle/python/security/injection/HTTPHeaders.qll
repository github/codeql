import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

class HeaderInjectionFlowConfig extends TaintTracking::Configuration {
  HeaderInjectionFlowConfig() { this = "HeaderInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(HeaderDeclaration headerDeclaration).getHeaderInputNode()
  }
}
