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
  DollarAtString package, DollarAtString type, DollarAtString subtypes, DollarAtString name,
  DollarAtString signature, DollarAtString input, DollarAtString output,
  DollarAtString parameterName, DollarAtString extensibleType
where
  isNegativeExample(endpoint, characteristic, confidence, package, type, subtypes, name, signature,
    input, output, parameterName, extensibleType)
select endpoint,
  characteristic + "\nrelated locations: $@, $@." +
    "\nmetadata: $@, $@, $@, $@, $@, $@, $@, $@, $@.", //
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
