import semmle.code.xml.XML
import TestUtilities.InlineExpectationsTest

class XmlTest extends InlineExpectationsTest {
  XmlTest() { this = "XmlTest" }

  override string getARelevantTag() { result = "hasXmlResult" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXmlResult" and
    exists(XmlAttribute a |
      a.getLocation() = location and
      element = a.toString() and
      value = ""
    )
  }
}
