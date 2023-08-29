/**
 * Surfaces endpoints that are sinks with high confidence, for use as positive examples in the prompt.
 *
 * @name Positive examples (application mode)
 * @kind problem
 * @problem.severity recommendation
 * @id java/ml/extract-automodel-application-positive-examples
 * @tags internal extract automodel application-mode positive examples
 */

private import AutomodelApplicationModeCharacteristics
private import AutomodelEndpointTypes
private import AutomodelJavaUtil

from
  Endpoint endpoint, SinkType sinkType, ApplicationModeMetadataExtractor meta,
  DollarAtString package, DollarAtString type, DollarAtString subtypes, DollarAtString name,
  DollarAtString signature, DollarAtString input, DollarAtString isVarargsArray
where
  // Exclude endpoints that have contradictory endpoint characteristics, because we only want examples we're highly
  // certain about in the prompt.
  not erroneousEndpoints(endpoint, _, _, _, _, false) and
  meta.hasMetadata(endpoint, package, type, subtypes, name, signature, input, isVarargsArray) and
  // Extract positive examples of sinks belonging to the existing ATM query configurations.
  CharacteristicsImpl::isKnownSink(endpoint, sinkType, _) and
  exists(CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, CallContext()))
select endpoint.asNode(),
  sinkType + "\nrelated locations: $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@.", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, CallContext()), "CallContext", //
  package, "package", //
  type, "type", //
  subtypes, "subtypes", //
  name, "name", //
  signature, "signature", //
  input, "input", //
  isVarargsArray, "isVarargsArray"
