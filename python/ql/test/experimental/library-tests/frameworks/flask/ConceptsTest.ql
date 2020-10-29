import python
import experimental.meta.ConceptsTest

class DedicatedFlaskResponseTest extends HttpServerHttpResponseTest {
  DedicatedFlaskResponseTest() { file.getShortName() = "response_test.py" }
}

class OtherFlaskResponseTest extends HttpServerHttpResponseTest {
  OtherFlaskResponseTest() { not this instanceof DedicatedFlaskResponseTest }

  override string getARelevantTag() { result = "HttpResponse" }
}
