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
import experimental.adaptivethreatmodeling.EndpointFeatures as EndpointFeatures
import experimental.adaptivethreatmodeling.StandardEndpointFilters as StandardEndpointFilters
import extraction.NoFeaturizationRestrictionsConfig

query predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  (
    not exists(NosqlInjectionAtm::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
    not exists(SqlInjectionAtm::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
    not exists(TaintedPathAtm::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
    not exists(XssAtm::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
    StandardEndpointFilters::isArgumentToModeledFunction(endpoint)
  ) and
  EndpointFeatures::tokenFeatures(endpoint, featureName, featureValue)
}

query predicate invalidTokenFeatures(
  DataFlow::Node endpoint, string featureName, string featureValue
) {
  strictcount(string value | EndpointFeatures::tokenFeatures(endpoint, featureName, value)) > 1 and
  EndpointFeatures::tokenFeatures(endpoint, featureName, featureValue)
}
