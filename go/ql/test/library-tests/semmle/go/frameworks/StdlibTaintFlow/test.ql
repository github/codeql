import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module FileSystemAccessTest implements TestSig {
  string getARelevantTag() { result = "fsaccess" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FileSystemAccess f |
      f.getLocation() = location and
      element = f.toString() and
      value = f.getAPathArgument().toString() and
      tag = "fsaccess"
    )
  }
}

import MakeTest<FileSystemAccessTest>
