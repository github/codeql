import java
import semmle.code.java.security.CleartextStorageSharedPrefsQuery
import TestUtilities.InlineExpectationsTest

class CleartextStorageSharedPrefsTest extends InlineExpectationsTest {
  CleartextStorageSharedPrefsTest() { this = "CleartextStorageSharedPrefsTest" }

  override string getARelevantTag() { result = "hasCleartextStorageSharedPrefs" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasCleartextStorageSharedPrefs" and
    exists(SensitiveSource data, SharedPreferencesEditorMethodAccess s, Expr input, Expr store |
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
