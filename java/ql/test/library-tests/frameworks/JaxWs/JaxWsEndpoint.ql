import java
import semmle.code.java.frameworks.JaxWS
import utils.test.InlineExpectationsTest

module JaxWsEndpointTest implements TestSig {
  string getARelevantTag() { result = ["JaxWsEndpoint", "JaxWsEndpointRemoteMethod"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<JaxWsEndpointTest>
