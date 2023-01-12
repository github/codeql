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

/*
 * ****** WARNING: ******
 * Before calling this query, make sure there's no codex-generated data extension file in `java/ql/lib/ext`. Otherwise,
 * the ML-gnerarated, noisy sinks will end up poluting the positive examples used in the prompt!
 */

from
  DataFlow::Node sink, AtmConfig::AtmConfig config,
  EndpointCharacteristics::EndpointCharacteristic characteristic, float confidence
where
  characteristic.appliesToEndpoint(sink) and
  confidence >= characteristic.maximalConfidence() and
  characteristic.hasImplications(config.getASinkEndpointType(), true, confidence) and
  // If there are _any_ erroneous endpoints, return nothing. This will prevent us from accidentally running this query
  // when there's a codex-generated data extension file in `java/ql/lib/ext`.
  not EndpointCharacteristics::erroneousEndpoints(_, _, _, _, _)
select sink, characteristic.toString()
