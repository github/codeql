import javascript
import testUtilities.ConsistencyChecking

API::Node testInstance() { result = API::moduleImport("@example/test").getInstance() }

class Taint extends TaintTracking::Configuration {
  Taint() { this = "Taint" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CallNode).getCalleeName() = "source"
    or
    node = testInstance().getMember("getSource").getReturn().getAnImmediateUse()
  }

  override predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
    or
    node = testInstance().getMember("getSink").getAParameter().getARhs()
  }
}
