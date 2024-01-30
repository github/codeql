import java
import AutomodelApplicationModeCharacteristics as Characteristics
import AutomodelExtractionTests

module TestHelper implements TestHelperSig<Characteristics::ApplicationCandidatesImpl> {
  Location getEndpointLocation(Characteristics::Endpoint endpoint) {
    result = endpoint.asTop().getLocation()
  }

  predicate isCandidate(
    Characteristics::Endpoint endpoint, string name, string signature, string input, string output,
    string extensibleType
  ) {
    Characteristics::isCandidate(endpoint, _, _, _, name, signature, input, output, _,
      extensibleType, _)
  }

  predicate isPositiveExample(
    Characteristics::Endpoint endpoint, string endpointType, string name, string signature,
    string input, string output, string extensibleType
  ) {
    Characteristics::isPositiveExample(endpoint, endpointType, _, _, _, name, signature, input,
      output, _, extensibleType)
  }

  predicate isNegativeExample(
    Characteristics::Endpoint endpoint, string name, string signature, string input, string output,
    string extensibleType
  ) {
    Characteristics::isNegativeExample(endpoint, _, _, _, _, _, name, signature, input, output, _,
      extensibleType)
  }
}

import MakeTest<Extraction<Characteristics::ApplicationCandidatesImpl, TestHelper>>
