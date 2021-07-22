import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import semmle.python.dataflow.new.SensitiveDataSources

class SensitiveDataSourcesTest extends InlineExpectationsTest {
  SensitiveDataSourcesTest() { this = "SensitiveDataSourcesTest" }

  override string getARelevantTag() { result = "SensitiveDataSource" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SensitiveDataSource source |
      location = source.getLocation() and
      element = source.toString() and
      value = source.getClassification() and
      tag = "SensitiveDataSource"
    )
  }
}
