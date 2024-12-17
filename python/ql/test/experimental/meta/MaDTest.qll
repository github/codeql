import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.frameworks.data.ModelsAsData
// need to import Frameworks to get the actual modeling imported
private import semmle.python.Frameworks
// this import needs to be public to get the query predicates propagated to the actual test files
import utils.test.InlineExpectationsTest

module MadSinkTest implements TestSig {
  string getARelevantTag() {
    exists(string kind | exists(ModelOutput::getASinkNode(kind)) |
      result = "mad-sink[" + kind + "]"
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(DataFlow::Node sink, string kind |
      sink = ModelOutput::getASinkNode(kind).asSink() and
      location = sink.getLocation() and
      element = sink.toString() and
      value = prettyNodeForInlineTest(sink) and
      tag = "mad-sink[" + kind + "]"
    )
  }
}

module MadSourceTest implements TestSig {
  string getARelevantTag() {
    exists(string kind | exists(ModelOutput::getASourceNode(kind)) | result = "mad-source__" + kind)
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(DataFlow::Node source, string kind |
      source = ModelOutput::getASourceNode(kind).asSource() and
      location = source.getLocation() and
      element = source.toString() and
      value = prettyNodeForInlineTest(source) and
      tag = "mad-source__" + kind
    )
  }
}

import MakeTest<MergeTests<MadSinkTest, MadSourceTest>>
