/**
 * Surfaces endpoints that are sinks with high confidence, for use as positive examples in the prompt.
 *
 * @name Positive examples (experimental)
 * @kind problem
 * @severity info
 * @id java/ml/known-sink
 * @tags internal automodel extract examples positive
 */

private import java
private import semmle.code.java.security.ExternalAPIs as ExternalAPIs
private import AutomodelEndpointCharacteristics
private import AutomodelEndpointTypes

from Endpoint sink, SinkType sinkType, string message
where
  // Exclude endpoints that have contradictory endpoint characteristics, because we only want examples we're highly
  // certain about in the prompt.
  not erroneousEndpoints(sink, _, _, _, _, false) and
  // Extract positive examples of sinks belonging to the existing ATM query configurations.
  (
    CharacteristicsImpl::isKnownSink(sink, sinkType) and
    message =
      sinkType + "\n" +
        // Extract the needed metadata for this endpoint.
        any(string metadata | CharacteristicsImpl::hasMetadata(sink, metadata))
  )
select sink, message + "\nrelated locations: $@, $@",
  CharacteristicsImpl::getRelatedLocationOrCandidate(sink, "Callable-JavaDoc"),
  "Callable-JavaDoc", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(sink, "Class-JavaDoc"), "Class-JavaDoc" //
