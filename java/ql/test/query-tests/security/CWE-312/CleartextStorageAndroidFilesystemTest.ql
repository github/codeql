import java
import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery
import TestUtilities.InlineExpectationsTest

class CleartextStorageAndroidFilesystemTest extends InlineExpectationsTest {
  CleartextStorageAndroidFilesystemTest() { this = "CleartextStorageAndroidFilesystemTest" }

  override string getARelevantTag() { result = "hasCleartextStorageAndroidFilesystem" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasCleartextStorageAndroidFilesystem" and
    exists(SensitiveSource data, LocalFileOpenCall s, Expr input, Expr store |
      input = s.getAnInput() and
      store = s.getAStore() and
      data.flowsTo(input)
    |
      input.getLocation() = location and
      element = input.toString() and
      value = ""
    )
  }
}
