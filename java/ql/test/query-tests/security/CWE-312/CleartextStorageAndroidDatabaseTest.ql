import java
import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery
import TestUtilities.InlineExpectationsTest

class CleartextStorageAndroidDatabaseTest extends InlineExpectationsTest {
  CleartextStorageAndroidDatabaseTest() { this = "CleartextStorageAndroidDatabaseTest" }

  override string getARelevantTag() { result = "hasCleartextStorageAndroidDatabase" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasCleartextStorageAndroidDatabase" and
    exists(SensitiveSource data, LocalDatabaseOpenMethodAccess s, Expr input, Expr store |
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
