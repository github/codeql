import semmle.code.xml.XML
import TestUtilities.InlineExpectationsTest

class XMLTest extends InlineExpectationsTest {
  XMLTest() { this = "XMLTest" }

  override string getARelevantTag() { result = "hasXmlResult" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXmlResult" and
    exists(XMLAttribute a |
      a.getLocation() = location and
      element = a.toString() and
      value = ""
    )
  }
}
