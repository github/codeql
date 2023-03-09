import java
import semmle.code.java.security.InsecureLdapAuthQuery
import TestUtilities.InlineExpectationsTest

class InsecureLdapAuthenticationTest extends InlineExpectationsTest {
  InsecureLdapAuthenticationTest() { this = "InsecureLdapAuthentication" }

  override string getARelevantTag() { result = "hasInsecureLdapAuth" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsecureLdapAuth" and
    exists(DataFlow::Node sink | InsecureUrlFlowConfiguration::hasFlowTo(sink) |
      BasicAuthFlowConfiguration::hasFlowTo(sink) and
      not SslFlowConfiguration::hasFlowTo(sink) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
