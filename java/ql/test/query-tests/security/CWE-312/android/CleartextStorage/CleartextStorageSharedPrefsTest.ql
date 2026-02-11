import java
import semmle.code.java.security.CleartextStorageSharedPrefsQuery
import utils.test.InlineExpectationsTest

module CleartextStorageSharedPrefsTest implements TestSig {
  string getARelevantTag() { result = "hasCleartextStorageSharedPrefs" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasCleartextStorageSharedPrefs" and
    exists(SensitiveSource data, SharedPreferencesEditorMethodCall s, Expr input, Expr store |
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

import MakeTest<CleartextStorageSharedPrefsTest>
