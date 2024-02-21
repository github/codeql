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
    result in [
        "sourceModelCandidate", "sinkModelCandidate", // a candidate source/sink
        "positiveSourceExample", "positiveSinkExample", // a known source/sink
        "negativeSourceExample", "negativeSinkExample" // a known non-source/non-sink
      ]
  }

  /**
   * If `extensibleType` is `sourceModel` then the result is `ifSource`, if it
   * is `sinkModel` then the result is `ifSink`.
   */
  bindingset[extensibleType, ifSource, ifSink]
  private string ifSource(string extensibleType, string ifSource, string ifSink) {
    extensibleType = "sourceModel" and result = ifSource
    or
    extensibleType = "sinkModel" and result = ifSink
  }

  additional predicate selectEndpoint(
    Candidate::Endpoint endpoint, string name, string signature, string input, string output,
    string extensibleType, string tag, string suffix
  ) {
    TestHelper::isCandidate(endpoint, name, signature, input, output, extensibleType) and
    tag = ifSource(extensibleType, "sourceModelCandidate", "sinkModelCandidate") and
    suffix = ""
    or
    TestHelper::isNegativeExample(endpoint, name, signature, input, output, extensibleType) and
    tag = "negative" + ifSource(extensibleType, "Source", "Sink") + "Example" and
    suffix = ""
    or
    exists(string endpointType |
      TestHelper::isPositiveExample(endpoint, endpointType, name, signature, input, output,
        extensibleType) and
      tag = "positive" + ifSource(extensibleType, "Source", "Sink") + "Example" and
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
      value = name + signature + ":" + ifSource(extensibleType, output, input) + suffix
    )
  }
}
