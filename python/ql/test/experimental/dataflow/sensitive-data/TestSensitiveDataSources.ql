import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import semmle.python.dataflow.new.SensitiveDataSources
private import semmle.python.ApiGraphs

class SensitiveDataSourcesTest extends InlineExpectationsTest {
  SensitiveDataSourcesTest() { this = "SensitiveDataSourcesTest" }

  override string getARelevantTag() { result in ["SensitiveDataSource", "SensitiveUse"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SensitiveDataSource source |
      (
        location = source.getLocation() and
        element = source.toString() and
        value = source.getClassification() and
        tag = "SensitiveDataSource"
      )
      or
      exists(DataFlow::Node use |
        use = API::builtin("print").getACall().getArg(_) and
        DataFlow::localFlow(source, use) and
        location = use.getLocation() and
        element = use.toString() and
        value = source.getClassification() and
        tag = "SensitiveUse"

      )
    )
  }
}
