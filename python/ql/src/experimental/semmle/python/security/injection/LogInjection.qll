import python
import semmle.python.Concepts
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
class LogInjectionFlowConfig extends TaintTracking::Configuration {
  LogInjectionFlowConfig() { this = "LogInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(LogOutput logoutput).getAnInput() }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(CallNode call |
      node.asCfgNode() = call.getFunction().(AttrNode).getObject("replace") and
      call.getArg(0).getNode().(StrConst).getText() in ["\r\n", "\n"]
    )
  }
}
