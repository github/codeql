import java
import utils.test.InlineExpectationsTest
import semmle.code.java.security.AndroidCertificatePinningQuery

module Test implements TestSig {
  string getARelevantTag() { result = ["hasNoTrustedResult", "hasUntrustedResult"] }

  predicate hasActualResult(Location loc, string el, string tag, string value) {
    exists(DataFlow::Node node |
      missingPinning(node, _) and
      loc = node.getLocation() and
      el = node.toString() and
      value = "" and
      if trustedDomain(_) then tag = "hasUntrustedResult" else tag = "hasNoTrustedResult"
    )
  }
}

import MakeTest<Test>
