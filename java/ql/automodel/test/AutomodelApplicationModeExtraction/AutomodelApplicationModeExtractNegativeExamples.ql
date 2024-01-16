import java
import AutomodelApplicationModeCharacteristics
import TestUtilities.InlineExpectationsTest

module NegativeExampleTest implements TestSig {
  string getARelevantTag() { result = "negativeExample" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      Endpoint endpoint, string name, string signature, string input,
      string output, string extensibleType
    |
      isNegativeExample(endpoint, _, _, _, _, _, name, signature, input, output, _,
        extensibleType)
    |
      endpoint.asTop().getLocation() = location and
      endpoint.toString() = element and
      tag = "negativeExample" and
      // for source models only the output is relevant, and vice versa for sink models
      if extensibleType = "sourceModel"
      then value = name + signature + ":" + output
      else value = name + signature + ":" + input
    )
  }
}

import MakeTest<NegativeExampleTest>
