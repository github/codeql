import java
import AutomodelApplicationModeCharacteristics
import TestUtilities.InlineExpectationsTest

module PositiveExampleTest implements TestSig {
  string getARelevantTag() { result = "positiveExample" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      Endpoint endpoint, string endpointType, string name, string signature, string input,
      string output, string extensibleType
    |
      isPositiveExample(endpoint, endpointType, _, _, _, name, signature, input, output, _,
        extensibleType)
    |
      endpoint.asTop().getLocation() = location and
      endpoint.toString() = element and
      tag = "positiveExample" and
      // for source models only the output is relevant, and vice versa for sink models
      if extensibleType = "sourceModel"
      then value = name + signature + ":" + output + "(" + endpointType + ")"
      else value = name + signature + ":" + input + "(" + endpointType + ")"
    )
  }
}

import MakeTest<PositiveExampleTest>
