import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module FileSystemAccessTest implements TestSig {
  string getARelevantTag() { result = "FileSystemAccess" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FileSystemAccess fsa |
      fsa.getLocation() = location and
      element = fsa.getAPathArgument().toString() and
      value = fsa.getAPathArgument().toString() and
      tag = "FileSystemAccess"
    )
  }
}

import MakeTest<FileSystemAccessTest>
