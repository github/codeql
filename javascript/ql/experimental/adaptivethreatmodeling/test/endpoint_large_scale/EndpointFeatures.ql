/**
 * EndpointFeatures.ql
 *
 * This tests generic token-based featurization of all endpoint candidates for all of the security
 * queries we support. This is in comparison to the `ExtractEndpointData.qlref` test, which tests
 * just the endpoints we extract in the training data.
 */

import javascript
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
import experimental.adaptivethreatmodeling.XssATM as XssAtm
import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomAtm
import experimental.adaptivethreatmodeling.EndpointFeatures as EndpointFeatures
import extraction.NoFeaturizationRestrictionsConfig
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics

query predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  (
    not exists(any(NosqlInjectionAtm::NosqlInjectionAtmConfig cfg).getAReasonSinkExcluded(endpoint)) or
    not exists(any(SqlInjectionAtm::SqlInjectionAtmConfig cfg).getAReasonSinkExcluded(endpoint)) or
    not exists(any(TaintedPathAtm::TaintedPathAtmConfig cfg).getAReasonSinkExcluded(endpoint)) or
    not exists(any(XssAtm::DomBasedXssAtmConfig cfg).getAReasonSinkExcluded(endpoint)) or
    not exists(any(XssThroughDomAtm::XssThroughDomAtmConfig cfg).getAReasonSinkExcluded(endpoint)) or
    any(EndpointCharacteristics::IsArgumentToModeledFunctionCharacteristic characteristic)
        .appliesToEndpoint(endpoint)
  ) and
  EndpointFeatures::tokenFeatures(endpoint, featureName, featureValue)
}

query predicate invalidTokenFeatures(
  DataFlow::Node endpoint, string featureName, string featureValue
) {
  strictcount(string value | EndpointFeatures::tokenFeatures(endpoint, featureName, value)) > 1 and
  EndpointFeatures::tokenFeatures(endpoint, featureName, featureValue)
}
