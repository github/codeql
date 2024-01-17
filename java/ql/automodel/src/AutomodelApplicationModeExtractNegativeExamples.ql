/**
 * Surfaces endpoints that are non-sinks with high confidence, for use as negative examples in the prompt.
 *
 * @name Negative examples (application mode)
 * @kind problem
 * @problem.severity recommendation
 * @id java/ml/extract-automodel-application-negative-examples
 * @tags internal extract automodel application-mode negative examples
 */

private import java
private import AutomodelApplicationModeCharacteristics
private import AutomodelEndpointTypes
private import AutomodelJavaUtil

/**
 * Gets a sample of endpoints (of at most `limit` samples) for which the given characteristic applies.
 *
 * The main purpose of this helper predicate is to avoid selecting too many samples, as this may
 * cause the SARIF file to exceed the maximum size limit.
 */
bindingset[limit]
Endpoint getSampleForCharacteristic(EndpointCharacteristic c, int limit) {
  exists(int n, int num_endpoints | num_endpoints = count(Endpoint e | c.appliesToEndpoint(e)) |
    result =
      rank[n](Endpoint e, Location loc |
        loc = e.asTop().getLocation() and c.appliesToEndpoint(e)
      |
        e
        order by
          loc.getFile().getAbsolutePath(), loc.getStartLine(), loc.getStartColumn(),
          loc.getEndLine(), loc.getEndColumn()
      ) and
    // To avoid selecting samples that are too close together (as the ranking above goes by file
    // path first), we select `limit` evenly spaced samples from the ranked list of endpoints. By
    // default this would always include the first sample, so we add a random-chosen prime offset
    // to the first sample index, and reduce modulo the number of endpoints.
    // Finally, we add 1 to the result, as ranking results in a 1-indexed relation.
    n = 1 + (([0 .. limit - 1] * (num_endpoints / limit).floor() + 46337) % num_endpoints)
  )
}

predicate candidate(
  Endpoint endpoint, EndpointCharacteristic characteristic, float confidence, string package,
  string type, string subtypes, string name, string signature, string input, string output,
  string isVarargsArray, string extensibleType
) {
  // the node is known not to be an endpoint of any appropriate type
  forall(EndpointType tp | tp = CharacteristicsImpl::getAPotentialType(endpoint) |
    characteristic.hasImplications(tp, false, _)
  ) and
  // the lowest confidence across all endpoint types should be at least highConfidence
  confidence =
    min(float c |
      characteristic.hasImplications(CharacteristicsImpl::getAPotentialType(endpoint), false, c)
    ) and
  confidence >= SharedCharacteristics::highConfidence() and
  any(ApplicationModeMetadataExtractor meta)
      .hasMetadata(endpoint, package, type, subtypes, name, signature, input, output,
        isVarargsArray, _, extensibleType) and
  // It's valid for a node to be both a potential source/sanitizer and a sink. We don't want to include such nodes
  // as negative examples in the prompt, because they're ambiguous and might confuse the model, so we explicitly exclude them here.
  not exists(EndpointCharacteristic characteristic2, float confidence2 |
    characteristic2 != characteristic
  |
    characteristic2.appliesToEndpoint(endpoint) and
    confidence2 >= SharedCharacteristics::maximalConfidence() and
    characteristic2
        .hasImplications(CharacteristicsImpl::getAPotentialType(endpoint), true, confidence2)
  )
}

from
  Endpoint endpoint, EndpointCharacteristic characteristic, float confidence, string message,
  DollarAtString package, DollarAtString type, DollarAtString subtypes, DollarAtString name,
  DollarAtString signature, DollarAtString input, DollarAtString output,
  DollarAtString isVarargsArray, DollarAtString extensibleType
where
  endpoint = getSampleForCharacteristic(characteristic, 100) and
  candidate(endpoint, characteristic, confidence, package, type, subtypes, name, signature, input,
    output, isVarargsArray, extensibleType) and
  message = characteristic
select endpoint.asNode(),
  message + "\nrelated locations: $@, $@, $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@, $@.", //
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
