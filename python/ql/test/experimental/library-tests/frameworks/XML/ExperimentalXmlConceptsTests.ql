import python
import experimental.semmle.python.Concepts
import experimental.semmle.python.frameworks.Xml
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

class XmlParsingTest extends InlineExpectationsTest {
  XmlParsingTest() { this = "XmlParsingTest" }

  override string getARelevantTag() { result in ["input", "vuln"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(XML::XMLParsing parsing |
      exists(DataFlow::Node input |
        input = parsing.getAnInput() and
        location = input.getLocation() and
        element = input.toString() and
        value = prettyNodeForInlineTest(input) and
        tag = "input"
      )
      or
      exists(XML::XMLVulnerabilityKind kind |
        parsing.vulnerableTo(kind) and
        location = parsing.getLocation() and
        element = parsing.toString() and
        value = "'" + kind + "'" and
        tag = "vuln"
      )
    )
  }
}
