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
  Endpoint endpoint, EndpointType endpointType, ApplicationModeMetadataExtractor meta,
  DollarAtString package, DollarAtString type, DollarAtString subtypes, DollarAtString name,
  DollarAtString signature, DollarAtString input, DollarAtString output,
  DollarAtString isVarargsArray, DollarAtString extensibleType
where
  extensibleType = endpoint.getExtensibleType() and
  meta.hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, isVarargsArray) and
  // Extract positive examples of sinks belonging to the existing ATM query configurations.
  CharacteristicsImpl::isKnownAs(endpoint, endpointType, _) and
  exists(CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, CallContext()))
select endpoint.asNode(),
  endpointType + "\nrelated locations: $@, $@, $@." +
    "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@, $@.", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, CallContext()), "CallContext", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, MethodDoc()), "MethodDoc", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, ClassDoc()), "ClassDoc", //
  package, "package", //
  type, "type", //
  subtypes, "subtypes", //
  name, "name", //
  signature, "signature", //
  input, "input", //
  output, "output", //
  isVarargsArray, "isVarargsArray", //
  extensibleType, "extensibleType"
