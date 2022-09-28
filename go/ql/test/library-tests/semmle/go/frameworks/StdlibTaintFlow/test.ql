import go
import TestUtilities.InlineExpectationsTest

class FileSystemAccessTest extends InlineExpectationsTest {
  FileSystemAccessTest() { this = "FileSystemAccess" }

  override string getARelevantTag() { result = "fsaccess" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FileSystemAccess f |
      f.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = f.toString() and
      value = f.getAPathArgument().toString() and
      tag = "fsaccess"
    )
  }
}
