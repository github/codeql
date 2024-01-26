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

from
  Endpoint endpoint, EndpointCharacteristic characteristic, float confidence, string message,
  DollarAtString package, DollarAtString type, DollarAtString subtypes, DollarAtString name,
  DollarAtString signature, DollarAtString input, DollarAtString output,
  DollarAtString isVarargsArray, DollarAtString extensibleType
where
  endpoint = getSampleForCharacteristic(characteristic, 100) and
  isNegativeExample(endpoint, characteristic, confidence, package, type, subtypes, name, signature,
    input, output, isVarargsArray, extensibleType) and
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
