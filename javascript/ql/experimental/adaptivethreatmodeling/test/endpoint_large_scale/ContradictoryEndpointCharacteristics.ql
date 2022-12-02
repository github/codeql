/**
 * ContradictoryEndpointCharacteristics.ql
 *
 * This tests surfaces endpoints that have a set of characteristics are logically incompatible with one another (e.g one
 * high-confidence characteristic that implies a non-sink and another that implies a sink). If the test surfaces any
 * such endpoints, this is a hint that some of our endpoint characteristics may be need to be adjusted.
 */

import javascript
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics
private import experimental.adaptivethreatmodeling.EndpointTypes as EndpointTypes

/**
 * Holds if the given endpoint has a self-contradictory combination of characteristics. Detects errors in our endpoint
 * characteristics. Lists the problematic characterisitics and their implications for all such endpoints, together with
 * an error message indicating why this combination is problematic.
 */
query predicate erroneousEndpoints(
  DataFlow::Node endpoint, EndpointCharacteristics::EndpointCharacteristic characteristic,
  EndpointTypes::EndpointType endpointClass, float confidence, string errorMessage
) {
  // An endpoint's characteristics should not include positive indicators with medium/high confidence for more than one
  // class.
  exists(
    EndpointCharacteristics::EndpointCharacteristic characteristic2,
    EndpointTypes::EndpointType endpointClass2, float confidence2
  |
    endpointClass.getEncoding() != endpointClass2.getEncoding() and
    characteristic.appliesToEndpoint(endpoint) and
    characteristic2.appliesToEndpoint(endpoint) and
    characteristic.hasImplications(endpointClass, true, confidence) and
    characteristic2.hasImplications(endpointClass2, true, confidence2) and
    confidence > characteristic.mediumConfidence() and
    confidence2 > characteristic2.mediumConfidence() and
    // We currently know of several high-confidence negative characteristics that apply to some known sinks.
    // TODO: Experiment with lowering the confidence of `"FileSystemAccess"`, `"DOM"`, `"DatabaseAccess"`, and
    // `"JQueryArgument"`.
    not (
      characteristic = ["TaintedPathSink", "FileSystemAccess"] and
      characteristic2 = ["TaintedPathSink", "FileSystemAccess"]
      or
      characteristic = ["DomBasedXssSink", "DOM"] and
      characteristic2 = ["DomBasedXssSink", "DOM"]
      or
      characteristic = ["DomBasedXssSink", "JQueryArgument"] and
      characteristic2 = ["DomBasedXssSink", "JQueryArgument"]
      or
      characteristic = ["NosqlInjectionSink", "DatabaseAccess"] and
      characteristic2 = ["NosqlInjectionSink", "DatabaseAccess"]
      or
      characteristic = ["SqlInjectionSink", "DatabaseAccess"] and
      characteristic2 = ["SqlInjectionSink", "DatabaseAccess"]
    )
  ) and
  errorMessage = "Endpoint has high-confidence positive indicators for multiple classes"
  or
  // An enpoint's characteristics should not include positive indicators with medium/high confidence for some class and
  // also include negative indicators with medium/high confidence for this same class.
  exists(EndpointCharacteristics::EndpointCharacteristic characteristic2, float confidence2 |
    characteristic.appliesToEndpoint(endpoint) and
    characteristic2.appliesToEndpoint(endpoint) and
    characteristic.hasImplications(endpointClass, true, confidence) and
    characteristic2.hasImplications(endpointClass, false, confidence2) and
    confidence > characteristic.mediumConfidence() and
    confidence2 > characteristic2.mediumConfidence()
  ) and
  errorMessage = "Endpoint has high-confidence positive and negative indicators for the same class"
  or
  // The endpoint's characteristics should not include indicators with confidence outside of [0, 1].
  characteristic.appliesToEndpoint(endpoint) and
  characteristic.hasImplications(_, _, confidence) and
  (confidence < 0 or confidence > 1) and
  errorMessage = "Endpoint has an indicator with confidence outside of [0, 1]"
}
