/*
 * For internal use only.
 *
 * Query for finding misclassified endpoints which we can use to debug ML-powered queries.
 */

import javascript
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import experimental.adaptivethreatmodeling.ATMConfig
import experimental.adaptivethreatmodeling.BaseScoring
import experimental.adaptivethreatmodeling.EndpointFeatures as EndpointFeatures
import experimental.adaptivethreatmodeling.EndpointTypes
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations

/** Gets the positive endpoint type for which you wish to find misclassified examples. */
EndpointType getEndpointType() { result instanceof NosqlInjectionSinkType }

/** Get a positive endpoint. This will be run through the classifier to determine whether it is misclassified. */
DataFlow::Node getAPositiveEndpoint() { result instanceof NosqlInjection::Sink }

/** An ATM configuration to find misclassified endpoints of type `getEndpointType()`. */
class ExtractMisclassifiedEndpointsAtmConfig extends AtmConfig {
  ExtractMisclassifiedEndpointsAtmConfig() { this = "ExtractMisclassifiedEndpointsATMConfig" }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    sinkCandidate = getAPositiveEndpoint()
  }

  override EndpointType getASinkEndpointType() { result = getEndpointType() }
}

/** Get an endpoint from `getAPositiveEndpoint()` that is incorrectly excluded from the results. */
DataFlow::Node getAMisclassifedEndpoint() {
  any(ExtractMisclassifiedEndpointsAtmConfig config).isEffectiveSink(result) and
  not any(ScoringResults results).shouldResultBeIncluded(_, result)
}

/** The token features for each misclassified endpoint. */
query predicate tokenFeaturesForMisclassifiedEndpoints(
  DataFlow::Node endpoint, string featureName, string featureValue
) {
  endpoint = getAMisclassifedEndpoint() and
  EndpointFeatures::tokenFeatures(endpoint, featureName, featureValue)
}
