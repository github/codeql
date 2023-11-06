/**
 * Surfaces the endpoints that are not already known to be sinks, and are therefore used as candidates for
 * classification with an ML model.
 *
 * Note: This query does not actually classify the endpoints using the model.
 *
 * @name Automodel candidates (application mode)
 * @description A query to extract automodel candidates in application mode.
 * @kind problem
 * @problem.severity recommendation
 * @id java/ml/extract-automodel-application-candidates
 * @tags internal extract automodel application-mode candidates
 */

import java
private import AutomodelApplicationModeCharacteristics
private import AutomodelJavaUtil

/**
 * Gets a sample of endpoints (of at most `limit` samples) with the given method signature.
 *
 * The main purpose of this helper predicate is to avoid selecting too many candidates, as this may
 * cause the SARIF file to exceed the maximum size limit.
 */
bindingset[limit]
private Endpoint getSampleForSignature(
  int limit, string package, string type, string subtypes, string name, string signature,
  string input, string output, string isVarargs, string extensibleType
) {
  exists(int n, int num_endpoints, ApplicationModeMetadataExtractor meta |
    num_endpoints =
      count(Endpoint e |
        e.getExtensibleType() = extensibleType and
        meta.hasMetadata(e, package, type, subtypes, name, signature, input, output, isVarargs)
      )
  |
    result =
      rank[n](Endpoint e, Location loc |
        loc = e.asTop().getLocation() and
        e.getExtensibleType() = extensibleType and
        meta.hasMetadata(e, package, type, subtypes, name, signature, input, output, isVarargs)
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
  Endpoint endpoint, ApplicationModeMetadataExtractor meta, DollarAtString package,
  DollarAtString type, DollarAtString subtypes, DollarAtString name, DollarAtString signature,
  DollarAtString input, DollarAtString output, DollarAtString isVarargsArray,
  DollarAtString alreadyAiModeled, DollarAtString extensibleType
where
  not exists(CharacteristicsImpl::UninterestingToModelCharacteristic u |
    u.appliesToEndpoint(endpoint)
  ) and
  CharacteristicsImpl::isSinkCandidate(endpoint, _) and
  endpoint =
    getSampleForSignature(9, package, type, subtypes, name, signature, input, output,
      isVarargsArray, extensibleType) and
  // If a node is already modeled in MaD, we don't include it as a candidate. Otherwise, we might include it as a
  // candidate for query A, but the model will label it as a sink for one of the sink types of query B, for which it's
  // already a known sink. This would result in overlap between our detected sinks and the pre-existing modeling. We
  // assume that, if a sink has already been modeled in a MaD model, then it doesn't belong to any additional sink
  // types, and we don't need to reexamine it.
  (
    not CharacteristicsImpl::isModeled(endpoint, _, _, _) and alreadyAiModeled = ""
    or
    alreadyAiModeled.matches("%ai-%") and
    CharacteristicsImpl::isModeled(endpoint, _, _, alreadyAiModeled)
  ) and
  meta.hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, isVarargsArray) and
  includeAutomodelCandidate(package, type, name, signature)
select endpoint.asNode(),
  "Related locations: $@, $@, $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@, $@, $@.", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, CallContext()), "CallContext", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, MethodDoc()), "MethodDoc", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, ClassDoc()), "ClassDoc", //
  package, "package", //
  type, "type", //
  subtypes, "subtypes", //
  name, "name", // method name
  signature, "signature", //
  input, "input", //
  output, "output", //
  isVarargsArray, "isVarargsArray", //
  alreadyAiModeled, "alreadyAiModeled", //
  extensibleType, "extensibleType"
