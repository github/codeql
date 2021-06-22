import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.BarrierGuards

/**
 * A taint-tracking configuration for detecting XML External entities abuse.
 *
 * This configuration uses `RemoteFlowSource` as a source because there's no
 * risk at parsing not user-supplied input without security options enabled.
 */
class XXEFlowConfig extends TaintTracking::Configuration {
  XXEFlowConfig() { this = "XXEFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(XMLParsing xmlParsing | xmlParsing.mayBeDangerous() and sink = xmlParsing.getAnInput())
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare
  }
}
