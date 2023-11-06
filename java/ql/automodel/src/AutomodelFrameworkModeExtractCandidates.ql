/**
 * Surfaces the endpoints that are not already known to be sinks, and are therefore used as candidates for
 * classification with an ML model.
 *
 * Note: This query does not actually classify the endpoints using the model.
 *
 * @name Automodel candidates (framework mode)
 * @description A query to extract automodel candidates in framework mode.
 * @kind problem
 * @problem.severity recommendation
 * @id java/ml/extract-automodel-framework-candidates
 * @tags internal extract automodel framework-mode candidates
 */

private import AutomodelFrameworkModeCharacteristics
private import AutomodelJavaUtil

from
  Endpoint endpoint, FrameworkModeMetadataExtractor meta, DollarAtString package,
  DollarAtString type, DollarAtString subtypes, DollarAtString name, DollarAtString signature,
  DollarAtString input, DollarAtString output, DollarAtString parameterName,
  DollarAtString alreadyAiModeled, DollarAtString extensibleType
where
  endpoint.getExtensibleType() = extensibleType and
  not exists(CharacteristicsImpl::UninterestingToModelCharacteristic u |
    u.appliesToEndpoint(endpoint)
  ) and
  CharacteristicsImpl::isSinkCandidate(endpoint, _) and
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
  meta.hasMetadata(endpoint, package, type, subtypes, name, signature, input, output, parameterName) and
  includeAutomodelCandidate(package, type, name, signature)
select endpoint,
  "Related locations: $@, $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@, $@, $@.", //
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
  alreadyAiModeled, "alreadyAiModeled", //
  extensibleType, "extensibleType"
