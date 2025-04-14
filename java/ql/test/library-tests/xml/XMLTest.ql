import semmle.code.xml.XML
import utils.test.InlineExpectationsTest

module XmlTest implements TestSig {
  string getARelevantTag() { result = "hasXmlResult" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXmlResult" and
    exists(XmlAttribute a |
      a.getLocation() = location and
      element = a.toString() and
      value = ""
    )
  }
}

import MakeTest<XmlTest>
