import javascript
import testUtilities.ConsistencyChecking

class BasicTaint extends TaintTracking::Configuration {
  BasicTaint() { this = "BasicTaint" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CallNode).getCalleeName() = "source"
  }

  override predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}
