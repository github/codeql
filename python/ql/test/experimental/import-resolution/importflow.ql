import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import TestUtilities.InlineExpectationsTest

private class SourceString extends DataFlow::Node {
  string contents;

  SourceString() {
    this.asExpr().(StrConst).getText() = contents and
    this.asExpr().getParent() instanceof Assign
  }

  string getContents() { result = contents }
}

private class ImportConfiguration extends DataFlow::Configuration {
  ImportConfiguration() { this = "ImportConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof SourceString }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("trace").getMember("check").getACall().getArg(1)
  }
}

class ResolutionTest extends InlineExpectationsTest {
  ResolutionTest() { this = "ResolutionTest" }

  override string getARelevantTag() { result = "import" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::PathNode source, DataFlow::PathNode sink, ImportConfiguration config |
      config.hasFlowPath(source, sink) and
      tag = "prints" and
      location = sink.getNode().getLocation() and
      value = source.getNode().(SourceString).getContents() and
      element = sink.getNode().toString()
    )
  }
}
