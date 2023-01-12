/**
 * Surfaces endpoints are sinks with high confidence, for use as positive examples in the prompt.
 *
 * @name Positive examples (experimental)
 * @kind problem
 * @id java/ml-powered/known-sink
 * @tags experimental security
 */

private import java
import semmle.code.java.dataflow.TaintTracking
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.RequestForgeryATM as RequestForgeryAtm

from
  DataFlow::Node sink, AtmConfig::AtmConfig config,
  EndpointCharacteristics::EndpointCharacteristic characteristic, float confidence
where
  characteristic.appliesToEndpoint(sink) and
  confidence >= characteristic.maximalConfidence() and
  characteristic.hasImplications(config.getASinkEndpointType(), true, confidence) and
  // Exclude sinks that have contradictory endpoint characteristics, because we only want examples we're highly certain
  // about in the prompt.
  not EndpointCharacteristics::erroneousEndpoints(sink, _, _, _, _)
select sink, characteristic.toString()
