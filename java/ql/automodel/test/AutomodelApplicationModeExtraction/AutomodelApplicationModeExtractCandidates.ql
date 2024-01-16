import java
import AutomodelApplicationModeCharacteristics
import TestUtilities.InlineExpectationsTest

module CandidateTest implements TestSig {
  string getARelevantTag() { result in ["sourceModel", "sinkModel"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      Endpoint endpoint, string name, string signature, string input, string output,
      string extensibleType
    |
      isCandidate(endpoint, _, _, _, name, signature, input, output, _, extensibleType, _)
    |
      endpoint.asTop().getLocation() = location and
      endpoint.toString() = element and
      tag = extensibleType and
      // for source models only the output is relevant, and vice versa for sink models
      if extensibleType = "sourceModel"
      then value = name + signature + ":" + output
      else value = name + signature + ":" + input
    )
  }
}

import MakeTest<CandidateTest>
