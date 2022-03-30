// /**
//  * @kind path-problem
//  */
import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TestUtilities.InlineExpectationsTest
import semmle.python.dataflow.new.SensitiveDataSources
private import semmle.python.ApiGraphs

class SensitiveDataSourcesTest extends InlineExpectationsTest {
  SensitiveDataSourcesTest() { this = "SensitiveDataSourcesTest" }

  override string getARelevantTag() { result in ["SensitiveDataSource", "SensitiveUse"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SensitiveDataSource source |
      location = source.getLocation() and
      element = source.toString() and
      value = source.getClassification() and
      tag = "SensitiveDataSource"
      or
      exists(DataFlow::Node use |
        any(SensitiveUseConfiguration config).hasFlow(source, use) and
        location = use.getLocation() and
        element = use.toString() and
        value = source.getClassification() and
        tag = "SensitiveUse"
      )
    )
  }
}

class SensitiveUseConfiguration extends TaintTracking::Configuration {
  SensitiveUseConfiguration() { this = "SensitiveUseConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof SensitiveDataSource }

  override predicate isSink(DataFlow::Node node) {
    node = API::builtin("print").getACall().getArg(_)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    sensitiveDataExtraStepForCalls(node1, node2)
  }
}
// import DataFlow::PathGraph
// from SensitiveUseConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
// where cfg.hasFlowPath(source, sink)
// select sink, source, sink, "taint from $@", source.getNode(), "here"
