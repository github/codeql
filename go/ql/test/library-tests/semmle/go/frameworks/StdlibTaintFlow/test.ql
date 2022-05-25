import go
import TestUtilities.InlineExpectationsTest

class FileSystemAccessTest extends InlineExpectationsTest {
  FileSystemAccessTest() { this = "FileSystemAccess" }

  override string getARelevantTag() { result = "fsaccess" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(FileSystemAccess f |
      f.hasLocationInfo(file, line, _, _, _) and
      element = f.toString() and
      value = f.getAPathArgument().toString() and
      tag = "fsaccess"
    )
  }
}
