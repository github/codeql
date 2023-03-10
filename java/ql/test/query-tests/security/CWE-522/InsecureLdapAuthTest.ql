import java
import semmle.code.java.security.InsecureLdapAuthQuery
import TestUtilities.InlineExpectationsTest

class InsecureLdapAuthenticationTest extends InlineExpectationsTest {
  InsecureLdapAuthenticationTest() { this = "InsecureLdapAuthentication" }

  override string getARelevantTag() { result = "hasInsecureLdapAuth" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsecureLdapAuth" and
    exists(DataFlow::Node sink | InsecureLdapUrlFlow::hasFlowTo(sink) |
      BasicAuthFlow::hasFlowTo(sink) and
      not RequiresSslFlow::hasFlowTo(sink) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
