import python
import experimental.meta.ConceptsTest

class DedicatedResponseTest extends HttpServerHttpResponseTest {
  DedicatedResponseTest() { file.getShortName() = "response_test.py" }
}

class OtherResponseTest extends HttpServerHttpResponseTest {
  OtherResponseTest() { not this instanceof DedicatedResponseTest }

  override string getARelevantTag() { result = "HttpResponse" }
}
