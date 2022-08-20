/**
 * EndpointFeatures.ql
 *
 * This tests generic token-based featurization of all endpoint candidates for all of the security
 * queries we support. This is in comparison to the `ExtractEndpointData.qlref` test, which tests
 * just the endpoints we extract in the training data.
 */

import javascript
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM
import experimental.adaptivethreatmodeling.EndpointFeatures as EndpointFeatures
import experimental.adaptivethreatmodeling.StandardEndpointFilters as StandardEndpointFilters
import extraction.NoFeaturizationRestrictionsConfig

query predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  (
    not exists(NosqlInjectionATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
    not exists(SqlInjectionATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
    not exists(TaintedPathATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
    not exists(XssATM::SinkEndpointFilter::getAReasonSinkExcluded(endpoint)) or
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
