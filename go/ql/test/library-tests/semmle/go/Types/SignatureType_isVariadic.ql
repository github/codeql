import go
import TestUtilities.InlineExpectationsTest

class SignatureTypeIsVariadicTest extends InlineExpectationsTest {
  SignatureTypeIsVariadicTest() { this = "SignatureType::IsVariadicTest" }

  override string getARelevantTag() { result = "isVariadic" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(FuncDef fd |
      fd.isVariadic() and
      fd.hasLocationInfo(file, line, _, _, _) and
      element = fd.toString() and
      value = "" and
      tag = "isVariadic"
    )
  }
}
