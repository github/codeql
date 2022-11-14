import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.AndroidCertificatePinningQuery

class Test extends InlineExpectationsTest {
  Test() { this = "AndroidMissingCertificatePinningTest" }

  override string getARelevantTag() { result = ["hasNoTrustedResult", "hasUntrustedResult"] }

  override predicate hasActualResult(Location loc, string el, string tag, string value) {
    exists(DataFlow::Node node |
      missingPinning(node) and
      loc = node.getLocation() and
      el = node.toString() and
      value = "" and
      (
        if exists(string x | trustedDomain(x))
        then tag = "hasUntrustedResult"
        else tag = "hasNoTrustedResult"
      )
    )
  }
}
