import java
import semmle.code.java.security.InsecureLdapAuthQuery
import utils.test.InlineExpectationsTest

module InsecureLdapAuthenticationTest implements TestSig {
  string getARelevantTag() { result = "hasInsecureLdapAuth" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsecureLdapAuth" and
    exists(DataFlow::Node sink | InsecureLdapUrlFlow::flowTo(sink) |
      BasicAuthFlow::flowTo(sink) and
      not RequiresSslFlow::flowTo(sink) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<InsecureLdapAuthenticationTest>
