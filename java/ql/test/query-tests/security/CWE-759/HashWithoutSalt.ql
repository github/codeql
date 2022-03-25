import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.HashWithoutSaltQuery

class HashWithoutSaltTest extends InlineExpectationsTest {
  HashWithoutSaltTest() { this = "HashWithoutSaltTest" }

  override string getARelevantTag() { result = "hasResult" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Variable pw, Expr hash |
      tag = "hasResult" and
      value = "" and
      passwordHashWithoutSalt(pw, hash) and
      location = hash.getLocation() and
      element = hash.toString()
    )
  }
}
