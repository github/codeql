import java
import semmle.code.java.frameworks.JaxWS
import TestUtilities.InlineExpectationsTest

class JaxWsEndpointTest extends InlineExpectationsTest {
  JaxWsEndpointTest() { this = "JaxWsEndpointTest" }

  override string getARelevantTag() { result = ["JaxWsEndpoint", "JaxWsEndpointRemoteMethod"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "JaxWsEndpoint" and
    exists(JaxWsEndpoint jaxWsEndpoint |
      jaxWsEndpoint.getLocation() = location and
      element = jaxWsEndpoint.toString() and
      value = ""
    )
    or
    tag = "JaxWsEndpointRemoteMethod" and
    exists(Callable remoteMethod |
      remoteMethod = any(JaxWsEndpoint jaxWsEndpoint).getARemoteMethod()
    |
      remoteMethod.getLocation() = location and
      element = remoteMethod.toString() and
      value = ""
    )
  }
}
