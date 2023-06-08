/**
 * Surfaces endpoints that are non-sinks with high confidence, for use as negative examples in the prompt.
 *
 * @name Negative examples (experimental)
 * @kind problem
 * @severity info
 * @id java/ml/non-sink
 * @tags internal automodel extract examples negative
 */

private import AutomodelFrameworkModeCharacteristics
private import AutomodelEndpointTypes
private import AutomodelSharedUtil

from
  Endpoint endpoint, EndpointCharacteristic characteristic, float confidence, string message,
  MetadataExtractor meta, string package, string type, boolean subtypes, string name,
  string signature, int input, string parameterName
where
  characteristic.appliesToEndpoint(endpoint) and
  confidence >= SharedCharacteristics::highConfidence() and
  characteristic.hasImplications(any(NegativeSinkType negative), true, confidence) and
  // Exclude endpoints that have contradictory endpoint characteristics, because we only want examples we're highly
  // certain about in the prompt.
  not erroneousEndpoints(endpoint, _, _, _, _, false) and
  meta.hasMetadata(endpoint, package, type, subtypes, name, signature, input, parameterName) and
  // It's valid for a node to satisfy the logic for both `isSink` and `isSanitizer`, but in that case it will be
  // treated by the actual query as a sanitizer, since the final logic is something like
  // `isSink(n) and not isSanitizer(n)`. We don't want to include such nodes as negative examples in the prompt, because
  // they're ambiguous and might confuse the model, so we explicitly exclude all known sinks from the negative examples.
  not exists(EndpointCharacteristic characteristic2, float confidence2, SinkType positiveType |
    not positiveType instanceof NegativeSinkType and
    characteristic2.appliesToEndpoint(endpoint) and
    confidence2 >= SharedCharacteristics::maximalConfidence() and
    characteristic2.hasImplications(positiveType, true, confidence2)
  ) and
  message = characteristic
select endpoint,
  message + "\nrelated locations: $@, $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@.", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, MethodDoc()), "MethodDoc", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, ClassDoc()), "ClassDoc", //
  package.(DollarAtString), "package", //
  type.(DollarAtString), "type", //
  subtypes.toString().(DollarAtString), "subtypes", //
  name.(DollarAtString), "name", //
  signature.(DollarAtString), "signature", //
  input.toString().(DollarAtString), "input", //
  parameterName.(DollarAtString), "parameterName" //
