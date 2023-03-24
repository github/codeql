import java
import semmle.code.java.security.AndroidWebViewCertificateValidationQuery
import TestUtilities.InlineExpectationsTest

class WebViewTest extends InlineExpectationsTest {
  WebViewTest() { this = "WebViewTest" }

  override string getARelevantTag() { result = "hasResult" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(OnReceivedSslErrorMethod m |
      trustsAllCerts(m) and
      location = m.getLocation() and
      element = m.toString() and
      tag = "hasResult" and
      value = ""
    )
  }
}
