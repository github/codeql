/*
 * For internal use only.
 *
 * Extracts training data we can use to train ML models for ML-powered queries.
 */

import javascript
import ExtractEndpointDataTraining as ExtractEndpointDataTraining

query predicate endpoints(
  DataFlow::Node endpoint, string queryName, string key, string value, string valueType
) {
  ExtractEndpointDataTraining::endpoints(endpoint, queryName, key, value, valueType) and
  // only select endpoints that are either Sink or NotASink
  ExtractEndpointDataTraining::endpoints(endpoint, queryName, "sinkLabel", ["Sink", "NotASink"],
    "string") and
  // do not select endpoints filtered out by end-to-end evaluation
  ExtractEndpointDataTraining::endpoints(endpoint, queryName, "isExcludedFromEndToEndEvaluation",
    "false", "boolean") and
  // only select endpoints that can be part of a tainted flow
  ExtractEndpointDataTraining::endpoints(endpoint, queryName, "isConstantExpression", "false",
    "boolean")
}

query predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  endpoints(endpoint, _, _, _, _) and
  ExtractEndpointDataTraining::tokenFeatures(endpoint, featureName, featureValue)
}
