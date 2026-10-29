import java
import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery
import utils.test.InlineExpectationsTest

module CleartextStorageAndroidDatabaseTest implements TestSig {
  string getARelevantTag() { result = "hasCleartextStorageAndroidDatabase" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasCleartextStorageAndroidDatabase" and
    exists(SensitiveSource data, LocalDatabaseOpenMethodCall s, Expr input, Expr store |
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

import MakeTest<CleartextStorageAndroidDatabaseTest>
