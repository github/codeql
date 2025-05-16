import javascript
import testUtilities.InlineExpectationsTest

module TestConfig implements TestSig {
  string getARelevantTag() { result = ["middleware", "secure"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    tag = "middleware" and
    exists(ExpressValidator::MiddlewareInstance middleware |
      location = middleware.getAstNode().getLocation() and
      value = middleware.getValidatorType() + "::" + middleware.getSafeParameterName()
    )
    or
    element = "" and
    tag = "secure" and
    exists(DataFlow::Node safe, ExpressValidator::MiddlewareInstance middleware |
      safe = middleware.getSecureRequestInputAccess() and
      location = safe.getAstNode().getLocation() and
      value = safe.toString()
    )
  }
}

import MakeTest<TestConfig>
