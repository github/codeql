/**
 * Surfaces the endpoints that pass the endpoint filters and are not already known to be sinks, and are therefore used
 * as candidates for classification with an ML model.
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

/**
 * Holds if the candidate sink `candidateSink` should be considered as a possible sink of type `sinkType`, and
 * classified by the ML model. A candidate sink is a node that cannot be excluded form `sinkType` based on its
 * characteristics.
 */
predicate isEffectiveSink(DataFlow::Node candidateSink, SinkType sinkType) {
  sinkType != any(NegativeSinkType negative) and
  not exists(EndpointCharacteristics::EndpointCharacteristic characteristic |
    characteristic = getAReasonSinkExcluded(candidateSink, sinkType)
  )
}

/**
 * Gets the list of characteristics that cause `candidateSink` to be excluded as an effective sink for a given sink
 * type.
 */
EndpointCharacteristics::EndpointCharacteristic getAReasonSinkExcluded(
  DataFlow::Node candidateSink, SinkType sinkType
) {
  // An endpoint is a sink candidate if none of its characteristics give much indication whether or not it is a sink.
  sinkType != any(NegativeSinkType negative) and
  result.appliesToEndpoint(candidateSink) and
  // Exclude endpoints that have a characteristic that implies they're not sinks for _any_ sink type.
  exists(float confidence |
    confidence >= result.mediumConfidence() and
    result.hasImplications(any(NegativeSinkType negative), true, confidence)
  )
  or
  // Exclude endpoints that have a characteristic that implies they're not sinks for _this particular_ sink type.
  exists(float confidence |
    confidence >= result.mediumConfidence() and
    result.hasImplications(sinkType, false, confidence)
  )
}

from DataFlow::Node sinkCandidate, string message
where
  // If a node is already a known sink for any of our existing ATM queries and is already modeled as a MaD sink, we
  // don't include it as a candidate. Otherwise, we might include it as a candidate for query A, but the model will
  // label it as a sink for one of the sink types of query B, for which it's already a known sink. This would result in
  // overlap between our detected sinks and the pre-existing modeling. We assume that, if a sink has already been
  // modeled in a MaD model, then it doesn't belong to any additional sink types, and we don't need to reexamine it.
  not exists(string kind |
    sinkNode(sinkCandidate, kind)
    // and EndpointCharacteristics::isKnownSink(sinkCandidate, sinkType) and kind = sinkType.getKind() // TODO: Uncomment this line once our sink types indeed correspond to MaD `kind`s.
  ) and
  // The message is the concatenation of all sink types for which this endpoint is known neither to be a sink nor to be
  // a non-sink, and we surface only endpoints that have at least one such sink type.
  message =
    strictconcat(SinkType sinkType |
        not EndpointCharacteristics::isKnownSink(sinkCandidate, sinkType) and
        isEffectiveSink(sinkCandidate, sinkType)
      |
        sinkType + ", "
      ) + "\n" +
      // Extract the needed metadata for this endpoint.
      any(string metadata | EndpointCharacteristics::hasMetadata(sinkCandidate, metadata))
select sinkCandidate, message
