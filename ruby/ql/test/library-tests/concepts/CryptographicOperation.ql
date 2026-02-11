import codeql.ruby.AST
import codeql.ruby.Concepts
import utils.test.InlineExpectationsTest

module CryptographicOperationTest implements TestSig {
  string getARelevantTag() {
    result in [
        "CryptographicOperation", "CryptographicOperationInput", "CryptographicOperationAlgorithm",
        "CryptographicOperationBlockMode"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<CryptographicOperationTest>
