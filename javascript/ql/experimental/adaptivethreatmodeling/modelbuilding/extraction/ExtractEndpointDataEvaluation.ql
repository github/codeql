/*
 * For internal use only.
 *
 * Extracts evaluation data we can use to evaluate ML models for ML-powered queries.
 */

import javascript
import ExtractEndpointDataEvaluation as ExtractEndpointDataEvaluation

query predicate endpoints(
  DataFlow::Node endpoint, string queryName, string key, string value, string valueType
) {
  ExtractEndpointDataEvaluation::endpoints(endpoint, queryName, key, value, valueType) and
  // only select endpoints that are either Sink, NotASink or Unknown
  ExtractEndpointDataEvaluation::endpoints(endpoint, queryName, "sinkLabel", ["Sink", "NotASink", "Unknown"],
    "string") and
  // do not select endpoints filtered out by end-to-end evaluation
  ExtractEndpointDataEvaluation::endpoints(endpoint, queryName, "isExcludedFromEndToEndEvaluation", "false",
    "boolean")
}

query predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  endpoints(endpoint, _, _, _, _) and
  ExtractEndpointDataEvaluation::tokenFeatures(endpoint, featureName, featureValue)
}
