import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

module FileSystemAccessTest implements TestSig {
  string getARelevantTag() { result = "getAPathArgument" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(FileSystemAccess a, DataFlow::Node path |
      path = a.getAPathArgument() and
      location = a.getLocation() and
      element = path.toString() and
      value = prettyNodeForInlineTest(path) and
      tag = "getAPathArgument"
    )
  }
}
