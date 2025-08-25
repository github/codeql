import java
import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery
import utils.test.InlineExpectationsTest

module CleartextStorageAndroidFilesystemTest implements TestSig {
  string getARelevantTag() { result = "hasCleartextStorageAndroidFilesystem" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<CleartextStorageAndroidFilesystemTest>
