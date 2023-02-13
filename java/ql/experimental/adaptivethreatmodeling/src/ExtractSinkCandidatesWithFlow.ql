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
private import semmle.code.java.dataflow.ExternalFlow
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics
private import experimental.adaptivethreatmodeling.EndpointTypes
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.RequestForgeryATM as RequestForgeryAtm

from DataFlow::Node sink, string message
where
  // If a node is already a known sink for any of our existing ATM queries and is already modeled as a MaD sink, we
  // don't include it as a candidate. Otherwise, we might include it as a candidate for query A, but the model will
  // label it as a sink for one of the sink types of query B, for which it's already a known sink. This would result in
  // overlap between our detected sinks and the pre-existing modeling. We assume that, if a sink has already been
  // modeled in a MaD model, then it doesn't belong to any additional sink types, and we don't need to reexamine it.
  not exists(AtmConfig::AtmConfig config, string kind |
    config.isKnownSink(sink) and
    sinkNode(sink, kind)
  ) and
  // The message is the concatenation of all relevant configs, and we surface only sinks that have at least one relevant
  // config.
  message =
    strictconcat(AtmConfig::AtmConfig config, DataFlow::PathNode sinkPathNode |
        config.isSinkCandidateWithFlow(sinkPathNode) and
        sinkPathNode.getNode() = sink
      |
        config, ", "
      ) + "\n" +
      // Extract the needed metadata for this endpoint.
      any(string metadata | EndpointCharacteristics::hasMetadata(sink, metadata))
select sink, message
