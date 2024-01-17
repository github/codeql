import java
import TestUtilities.InlineExpectationsTest
import AutomodelSharedCharacteristics

signature module TestHelperSig<CandidateSig Candidate> {
  Location getEndpointLocation(Candidate::Endpoint e);

  predicate isCandidate(
    Candidate::Endpoint e, string name, string signature, string input, string output,
    string extensibleType
  );

  predicate isPositiveExample(
    Candidate::Endpoint e, string endpointType, string name, string signature, string input,
    string output, string extensibleType
  );

  predicate isNegativeExample(
    Candidate::Endpoint e, string name, string signature, string input, string output,
    string extensibleType
  );
}

module Extraction<CandidateSig Candidate, TestHelperSig<Candidate> TestHelper> implements TestSig {
  string getARelevantTag() {
    result in ["sourceModel", "sinkModel", "positiveExample", "negativeExample"]
  }

  additional predicate selectEndpoint(
    Candidate::Endpoint endpoint, string name, string signature, string input, string output,
    string extensibleType, string tag, string suffix
  ) {
    TestHelper::isCandidate(endpoint, name, signature, input, output, extensibleType) and
    tag = extensibleType and
    suffix = ""
    or
    TestHelper::isNegativeExample(endpoint, name, signature, input, output, extensibleType) and
    tag = "negativeExample" and
    suffix = ""
    or
    exists(string endpointType |
      TestHelper::isPositiveExample(endpoint, endpointType, name, signature, input, output,
        extensibleType) and
      tag = "positiveExample" and
      suffix = "(" + endpointType + ")"
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      Candidate::Endpoint endpoint, string name, string signature, string input, string output,
      string extensibleType, string suffix
    |
      selectEndpoint(endpoint, name, signature, input, output, extensibleType, tag, suffix)
    |
      TestHelper::getEndpointLocation(endpoint) = location and
      endpoint.toString() = element and
      // for source models only the output is relevant, and vice versa for sink models
      if extensibleType = "sourceModel"
      then value = name + signature + ":" + output + suffix
      else value = name + signature + ":" + input + suffix
    )
  }
}
