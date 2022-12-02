/*
 * ExtractEndpointDataInference.ql
 *
 * This test surfaces the endpoints that pass the endpoint filters and have flow from a source for each query config,
 * and are therefore used as candidates for scoring at inference time.
 *
 * This is equivalent to ExtractEndpointDataTraining.qlref, but testing the inference endpoints rather than the training
 * endpoints. It detects CodeQL changes that impact the endpoints that get scored at inference time.
 *
 * This test does not actually score the endpoints and test for changes in the model predictions: that gets done in the
 * integration tests.
 */

private import javascript as JS
import extraction.NoFeaturizationRestrictionsConfig
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.XssATM as XssAtm
private import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomAtm

query predicate isSinkCandidateForQuery(
  AtmConfig::AtmConfig queryConfig, JS::DataFlow::PathNode sink
) {
  queryConfig.isSinkCandidateWithFlow(sink)
}
