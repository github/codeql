/**
 * Surfaces endpoints that are non-sinks with high confidence, for use as negative examples in the prompt.
 *
 * @name Negative examples (framework mode)
 * @kind problem
 * @problem.severity recommendation
 * @id java/ml/extract-automodel-framework-negative-examples
 * @tags internal extract automodel framework-mode negative examples
 */

private import AutomodelFrameworkModeCharacteristics
private import AutomodelEndpointTypes
private import AutomodelJavaUtil

from
  Endpoint endpoint, EndpointCharacteristic characteristic, float confidence,
  DollarAtString message, FrameworkModeMetadataExtractor meta, DollarAtString package,
  DollarAtString type, DollarAtString subtypes, DollarAtString name, DollarAtString signature,
  DollarAtString input, DollarAtString output, DollarAtString parameterName,
  DollarAtString extensibleType
where
  characteristic.appliesToEndpoint(endpoint) and
  // the node is known not to be an endpoint of any appropriate type
  forall(EndpointType tp | tp = endpoint.getAPotentialType() |
    characteristic.hasImplications(tp, false, _)
  ) and
  // the lowest confidence across all endpoint types should be at least highConfidence
  confidence = min(float c | characteristic.hasImplications(endpoint.getAPotentialType(), false, c)) and
  confidence >= SharedCharacteristics::highConfidence() and
  meta.hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, parameterName,
    _, extensibleType) and
  // It's valid for a node to be both a potential source/sanitizer and a sink. We don't want to include such nodes
  // as negative examples in the prompt, because they're ambiguous and might confuse the model, so we explicitly them here.
  not exists(EndpointCharacteristic characteristic2, float confidence2 |
    characteristic2.appliesToEndpoint(endpoint) and
    confidence2 >= SharedCharacteristics::maximalConfidence() and
    characteristic2.hasImplications(endpoint.getAPotentialType(), true, confidence2)
  ) and
  message = characteristic
select endpoint,
  message + "\nrelated locations: $@, $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@, $@.", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, MethodDoc()), "MethodDoc", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, ClassDoc()), "ClassDoc", //
  package, "package", //
  type, "type", //
  subtypes, "subtypes", //
  name, "name", //
  signature, "signature", //
  input, "input", //
  output, "output", //
  parameterName, "parameterName", //
  extensibleType, "extensibleType"
