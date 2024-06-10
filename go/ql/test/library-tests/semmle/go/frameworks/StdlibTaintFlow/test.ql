import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineExpectationsTest

module FileSystemAccessTest implements TestSig {
  string getARelevantTag() { result = "fsaccess" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FileSystemAccess f |
      f.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = f.toString() and
      value = f.getAPathArgument().toString() and
      tag = "fsaccess"
    )
  }
}

import MakeTest<FileSystemAccessTest>
