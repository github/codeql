/**
 * Surfaces the endpoints that pass the endpoint filters and have flow from a source for each query config, and are
 * therefore used as candidates for classification with an ML model.
 *
 * Note: This query does not actually classify the endpoints using the model.
 *
 * @name Sink candidates with flow (experimental)
 * @description Sink candidates with flow from a source
 * @kind problem
 * @id java/ml-powered/sink-candidates-with-flow
 * @tags experimental security
 */

private import java
import semmle.code.java.dataflow.TaintTracking
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.RequestForgeryATM as RequestForgeryAtm

from DataFlow::Node sink, string message
where
  // The message is the concatenation of all relevant configs, and we surface only sinks that have at least one relevant
  // config.
  message =
    strictconcat(AtmConfig::AtmConfig config, DataFlow::PathNode sinkPathNode |
        config.isSinkCandidateWithFlow(sinkPathNode) and
        sinkPathNode.getNode() = sink
      |
        config.getASinkEndpointType().getDescription(), ", "
      ) + "\n" +
      // Extract the needed metadata for this endpoint.
      any(string metadata | EndpointCharacteristics::hasMetadata(sink, metadata))
select sink, message
