/**
 * Surfaces endpoints are non-sinks with high confidence, for use as negative examples in the prompt.
 *
 * @name Negative examples (experimental)
 * @kind problem
 * @id java/ml-powered/non-sink
 * @tags experimental security
 */

private import java
import semmle.code.java.dataflow.TaintTracking
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics
private import experimental.adaptivethreatmodeling.EndpointTypes

from
  DataFlow::Node sink, EndpointCharacteristics::EndpointCharacteristic characteristic,
  float confidence
where
  characteristic.appliesToEndpoint(sink) and
  confidence >= characteristic.highConfidence() and
  characteristic.hasImplications(any(NegativeType negative), true, confidence)
select sink, "Non-sink of type " + characteristic + " with confidence " + confidence.toString()
