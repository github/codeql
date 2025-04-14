// /**
//  * @kind path-problem
//  */
import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import utils.test.InlineExpectationsTest
import semmle.python.dataflow.new.SensitiveDataSources
private import semmle.python.ApiGraphs

module SensitiveDataSourcesTest implements TestSig {
  string getARelevantTag() { result in ["SensitiveDataSource", "SensitiveUse"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SensitiveDataSource source |
      location = source.getLocation() and
      element = source.toString() and
      value = source.getClassification() and
      tag = "SensitiveDataSource"
      or
      exists(DataFlow::Node use |
        SensitiveUseFlow::flow(source, use) and
        location = use.getLocation() and
        element = use.toString() and
        value = source.getClassification() and
        tag = "SensitiveUse"
      )
    )
  }
}

import MakeTest<SensitiveDataSourcesTest>

module SensitiveUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof SensitiveDataSource }

  predicate isSink(DataFlow::Node node) { node = API::builtin("print").getACall().getArg(_) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    sensitiveDataExtraStepForCalls(node1, node2)
  }
}

module SensitiveUseFlow = TaintTracking::Global<SensitiveUseConfig>;
// import DataFlow::PathGraph
// from SensitiveUseConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
// where cfg.hasFlowPath(source, sink)
// select sink, source, sink, "taint from $@", source.getNode(), "here"
