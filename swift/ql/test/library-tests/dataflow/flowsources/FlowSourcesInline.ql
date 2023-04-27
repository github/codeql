import swift
import TestUtilities.InlineExpectationsTest
import FlowConfig

string describe(FlowSource source) {
  source instanceof RemoteFlowSource and result = "remote"
  or
  source instanceof LocalFlowSource and result = "local"
}

class FlowSourcesTest extends InlineExpectationsTest {
  FlowSourcesTest() { this = "FlowSourcesTest" }

  override string getARelevantTag() { result = "source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FlowSource source |
      location = source.getLocation() and
      location.getFile().getBaseName() != "" and
      element = source.toString() and
      tag = "source" and
      value = describe(source)
    )
  }
}
