import go
import utils.test.InlineExpectationsTest

module SignatureTypeIsVariadicTest implements TestSig {
  string getARelevantTag() { result = "isVariadic" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<SignatureTypeIsVariadicTest>
