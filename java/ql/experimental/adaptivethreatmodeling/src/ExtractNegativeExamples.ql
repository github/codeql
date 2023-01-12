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

bindingset[rate]
DataFlow::Node getSampleFromSampleRate(float rate) {
  exists(int r |
    result =
      rank[r](DataFlow::Node n, string path, int a, int b, int c, int d |
        n.asExpr().getLocation().hasLocationInfo(path, a, b, c, d)
      |
        n order by path, a, b, c, d
      ) and
    r % (1 / rate).ceil() = 0
  )
}

from
  DataFlow::Node endpoint, EndpointCharacteristics::EndpointCharacteristic characteristic,
  float confidence
where
  characteristic.appliesToEndpoint(endpoint) and
  confidence >= characteristic.highConfidence() and
  characteristic.hasImplications(any(NegativeType negative), true, confidence) and
  // Exclude endpoints that have contradictory endpoint characteristics, because we only want examples we're highly
  // certain about in the prompt.
  not EndpointCharacteristics::erroneousEndpoints(endpoint, _, _, _, _) and
  endpoint = getSampleFromSampleRate(0.01)
select endpoint, "Non-sink of type " + characteristic + " with confidence " + confidence.toString()
