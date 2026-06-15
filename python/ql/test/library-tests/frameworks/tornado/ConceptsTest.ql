import python
import experimental.meta.ConceptsTest

class DedicatedTest extends DedicatedResponseTest {
  DedicatedTest() { this = "response_test.py" }

  override predicate isDedicatedFile(File file) { file.getShortName() = this }
}
