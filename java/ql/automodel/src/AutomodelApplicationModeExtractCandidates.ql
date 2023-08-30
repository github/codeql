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
  string input, string isVarargs
) {
  exists(int n, int num_endpoints, ApplicationModeMetadataExtractor meta |
    num_endpoints =
      count(Endpoint e |
        meta.hasMetadata(e, package, type, subtypes, name, signature, input, isVarargs)
      )
  |
    result =
      rank[n](Endpoint e, Location loc |
        loc = e.asTop().getLocation() and
        meta.hasMetadata(e, package, type, subtypes, name, signature, input, isVarargs)
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
  Endpoint endpoint, string message, ApplicationModeMetadataExtractor meta, DollarAtString package,
  DollarAtString type, DollarAtString subtypes, DollarAtString name, DollarAtString signature,
  DollarAtString input, DollarAtString isVarargsArray, DollarAtString alreadyAiModeled
where
  not exists(CharacteristicsImpl::UninterestingToModelCharacteristic u |
    u.appliesToEndpoint(endpoint)
  ) and
  endpoint =
    getSampleForSignature(9, package, type, subtypes, name, signature, input, isVarargsArray) and
  // If a node is already a known sink for any of our existing ATM queries and is already modeled as a MaD sink, we
  // don't include it as a candidate. Otherwise, we might include it as a candidate for query A, but the model will
  // label it as a sink for one of the sink types of query B, for which it's already a known sink. This would result in
  // overlap between our detected sinks and the pre-existing modeling. We assume that, if a sink has already been
  // modeled in a MaD model, then it doesn't belong to any additional sink types, and we don't need to reexamine it.
  (
    not CharacteristicsImpl::isSink(endpoint, _, _) and alreadyAiModeled = ""
    or
    alreadyAiModeled.matches("%ai-%") and
    CharacteristicsImpl::isSink(endpoint, _, alreadyAiModeled)
  ) and
  meta.hasMetadata(endpoint, package, type, subtypes, name, signature, input, isVarargsArray) and
  includeAutomodelCandidate(package, type, name, signature) and
  // The message is the concatenation of all sink types for which this endpoint is known neither to be a sink nor to be
  // a non-sink, and we surface only endpoints that have at least one such sink type.
  message =
    strictconcat(AutomodelEndpointTypes::SinkType sinkType |
      not CharacteristicsImpl::isKnownSink(endpoint, sinkType, _) and
      CharacteristicsImpl::isSinkCandidate(endpoint, sinkType)
    |
      sinkType, ", "
    )
select endpoint.asNode(),
  message + "\nrelated locations: $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@.", //
  CharacteristicsImpl::getRelatedLocationOrCandidate(endpoint, CallContext()), "CallContext", //
  package, "package", //
  type, "type", //
  subtypes, "subtypes", //
  name, "name", // method name
  signature, "signature", //
  input, "input", //
  isVarargsArray, "isVarargsArray", //
  alreadyAiModeled, "alreadyAiModeled"
