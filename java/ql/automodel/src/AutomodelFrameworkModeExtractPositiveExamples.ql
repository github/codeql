/**
 * Surfaces endpoints that are sinks with high confidence, for use as positive examples in the prompt.
 *
 * @name Positive examples (framework mode)
 * @kind problem
 * @problem.severity recommendation
 * @id java/ml/extract-automodel-framework-positive-examples
 * @tags internal extract automodel framework-mode positive examples
 */

private import AutomodelFrameworkModeCharacteristics
private import AutomodelEndpointTypes
private import AutomodelJavaUtil

from
  Endpoint endpoint, EndpointType endpointType, DollarAtString package, DollarAtString type,
  DollarAtString subtypes, DollarAtString name, DollarAtString signature, DollarAtString input,
  DollarAtString output, DollarAtString parameterName, DollarAtString extensibleType
where
  isPositiveExample(endpoint, endpointType, package, type, subtypes, name, signature, input, output,
    parameterName, extensibleType)
select endpoint,
  endpointType + "\nrelated locations: $@, $@." + "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@, $@.", //
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
