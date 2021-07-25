import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting HTTP Header injections.
 */
class HeaderInjectionFlowConfig extends TaintTracking::Configuration {
  HeaderInjectionFlowConfig() { this = "HeaderInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(HeaderDeclaration headerDeclaration |
      sink in [headerDeclaration.getNameArg(), headerDeclaration.getValueArg()]
    )
  }
}
