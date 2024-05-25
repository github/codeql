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
  Endpoint endpoint, DollarAtString package, DollarAtString type, DollarAtString subtypes,
  DollarAtString name, DollarAtString signature, DollarAtString input, DollarAtString output,
  DollarAtString parameterName, DollarAtString alreadyAiModeled, DollarAtString extensibleType
where
  isCandidate(endpoint, package, type, subtypes, name, signature, input, output, parameterName,
    extensibleType, alreadyAiModeled)
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
