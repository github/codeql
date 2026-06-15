import java
import semmle.code.java.security.AndroidWebViewCertificateValidationQuery
import utils.test.InlineExpectationsTest

module WebViewTest implements TestSig {
  string getARelevantTag() { result = "hasResult" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(OnReceivedSslErrorMethod m |
      trustsAllCerts(m) and
      location = m.getLocation() and
      element = m.toString() and
      tag = "hasResult" and
      value = ""
    )
  }
}

import MakeTest<WebViewTest>
