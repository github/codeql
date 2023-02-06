import go
import TestUtilities.InlineExpectationsTest

class SignatureTypeIsVariadicTest extends InlineExpectationsTest {
  SignatureTypeIsVariadicTest() { this = "SignatureType::IsVariadicTest" }

  override string getARelevantTag() { result = "isVariadic" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FuncDef fd |
      fd.isVariadic() and
      fd.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = fd.toString() and
      value = "" and
      tag = "isVariadic"
    )
  }
}
