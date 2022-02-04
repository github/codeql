/*
 * For internal use only.
 *
 * Extracts training data we can use to train ML models for ML-powered queries.
 */

import javascript
import ExtractEndpointData as ExtractEndpointData

query predicate endpoints(
  DataFlow::Node endpoint, string queryName, string key, string value, string valueType
) {
  ExtractEndpointData::endpoints(endpoint, queryName, key, value, valueType) and
  // only select endpoints that are either Sink or NotASink
  ExtractEndpointData::endpoints(endpoint, queryName, "sinkLabel", ["Sink", "NotASink"], "string") and
  // do not select endpoints filtered out by end-to-end evaluation
  ExtractEndpointData::endpoints(endpoint, queryName, "isExcludedFromEndToEndEvaluation", "false",
    "boolean") and
  // only select endpoints that can be part of a tainted flow
  ExtractEndpointData::endpoints(endpoint, queryName, "isConstantExpression", "false", "boolean")
}

query predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  endpoints(endpoint, _, _, _, _) and
  ExtractEndpointData::tokenFeatures(endpoint, featureName, featureValue)
}
