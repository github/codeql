import go
import utils.test.InlineExpectationsTest

module FasthttpFileSystemAccessTest implements TestSig {
  string getARelevantTag() { result = "FileSystemAccess" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FileSystemAccess fileSystemAccess, DataFlow::Node aPathArgument |
      aPathArgument = fileSystemAccess.getAPathArgument()
    |
      aPathArgument.getLocation() = location and
      element = aPathArgument.toString() and
      value = aPathArgument.toString() and
      tag = "FileSystemAccess"
    )
  }
}

import MakeTest<FasthttpFileSystemAccessTest>
