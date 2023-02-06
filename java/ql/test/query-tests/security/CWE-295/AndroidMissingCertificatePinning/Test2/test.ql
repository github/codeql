import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.AndroidCertificatePinningQuery

class Test extends InlineExpectationsTest {
  Test() { this = "AndroidMissingCertificatePinningTest" }

  override string getARelevantTag() { result = ["hasNoTrustedResult", "hasUntrustedResult"] }

  override predicate hasActualResult(Location loc, string el, string tag, string value) {
    exists(DataFlow::Node node |
      missingPinning(node, _) and
      loc = node.getLocation() and
      el = node.toString() and
      value = "" and
      if trustedDomain(_) then tag = "hasUntrustedResult" else tag = "hasNoTrustedResult"
    )
  }
}
