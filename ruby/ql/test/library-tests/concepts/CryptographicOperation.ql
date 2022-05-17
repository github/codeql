import ruby
import codeql.ruby.Concepts
import TestUtilities.InlineExpectationsTest

class CryptographicOperationTest extends InlineExpectationsTest {
  CryptographicOperationTest() { this = "CryptographicOperationTest" }

  override string getARelevantTag() {
    result in [
        "CryptographicOperation", "CryptographicOperationInput", "CryptographicOperationAlgorithm",
        "CryptographicOperationBlockMode"
      ]
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Cryptography::CryptographicOperation cryptoOperation |
      location = cryptoOperation.getLocation() and
      (
        element = cryptoOperation.toString() and
        value = "" and
        tag = "CryptographicOperation"
        or
        element = cryptoOperation.toString() and
        value = cryptoOperation.getAlgorithm().getName() and
        tag = "CryptographicOperationAlgorithm"
        or
        element = cryptoOperation.toString() and
        value = cryptoOperation.getBlockMode() and
        tag = "CryptographicOperationBlockMode"
      )
    )
  }
}
