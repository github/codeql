import go
import semmle.go.frameworks.GoKit
import TestUtilities.InlineExpectationsTest

class UntrustedFlowSourceTest extends InlineExpectationsTest {
  UntrustedFlowSourceTest() { this = "untrustedflowsourcetest" }

  override string getARelevantTag() { result = "source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(UntrustedFlowSource source |
      source
          .hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
            location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = source.toString() and
      value = "\"" + source.toString() + "\"" and
      tag = "source"
    )
  }
}
