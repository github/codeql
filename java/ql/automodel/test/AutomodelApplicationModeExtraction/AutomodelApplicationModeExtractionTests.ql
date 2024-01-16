import java
import AutomodelApplicationModeCharacteristics
import TestUtilities.InlineExpectationsTest

module Extraction implements TestSig {
  string getARelevantTag() {
    result in ["sourceModel", "sinkModel", "positiveExample", "negativeExample"]
  }

  additional predicate selectEndpoint(
    Endpoint endpoint, string name, string signature, string input, string output,
    string extensibleType, string tag, string suffix
  ) {
    isCandidate(endpoint, _, _, _, name, signature, input, output, _, extensibleType, _) and
    tag = extensibleType and
    suffix = ""
    or
    isNegativeExample(endpoint, _, _, _, _, _, name, signature, input, output, _, extensibleType) and
    tag = "negativeExample" and
    suffix = ""
    or
    exists(string endpointType |
      isPositiveExample(endpoint, endpointType, _, _, _, name, signature, input, output, _,
        extensibleType) and
      tag = "positiveExample" and
      suffix = "(" + endpointType + ")"
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      Endpoint endpoint, string name, string signature, string input, string output,
      string extensibleType, string suffix
    |
      selectEndpoint(endpoint, name, signature, input, output, extensibleType, tag, suffix)
    |
      endpoint.asTop().getLocation() = location and
      endpoint.toString() = element and
      // for source models only the output is relevant, and vice versa for sink models
      if extensibleType = "sourceModel"
      then value = name + signature + ":" + output + suffix
      else value = name + signature + ":" + input + suffix
    )
  }
}

import MakeTest<Extraction>
