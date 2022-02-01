/*
 * For internal use only.
 *
 * Extracts evaluation data we can use to evaluate ML models for ML-powered queries.
 */

import javascript
import ExtractEndpointData as ExtractEndpointData

query predicate endpoints(
  DataFlow::Node endpoint, string queryName, string key, string value, string valueType
) {
  ExtractEndpointData::endpoints(endpoint, queryName, key, value, valueType) and
  // only select endpoints that are either Sink, NotASink or Unknown
  ExtractEndpointData::endpoints(endpoint, queryName, "sinkLabel", ["Sink", "NotASink", "Unknown"],
    "string") and
  // do not select endpoints filtered out by end-to-end evaluation
  ExtractEndpointData::endpoints(endpoint, queryName, "isExcludedFromEndToEndEvaluation", "false",
    "boolean")
}

query predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  endpoints(endpoint, _, _, _, _) and
  ExtractEndpointData::tokenFeatures(endpoint, featureName, featureValue)
}
