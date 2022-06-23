/*
 * For internal use only.
 *
 * Extracts training data for SqlInjection we can use to train ML models for a ML-powered version.
 */

import experimental.adaptivethreatmodeling.ATMConfig
import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import javascript
import Queries
import ExtractEndpointData as ExtractEndpointData

/** Gets the ATM configuration object for the specified query. */
AtmConfig getAtmCfg(Query query) {
  query instanceof SqlInjectionQuery and
  result instanceof SqlInjectionATM::SqlInjectionAtmConfig
}

/** Gets the ATM data flow configuration for the specified query. */
DataFlow::Configuration getDataFlowCfg(Query query) {
  query instanceof SqlInjectionQuery and result instanceof SqlInjectionATM::Configuration
}

query predicate endpoints(
  DataFlow::Node endpoint, AtmConfig atmConfig, DataFlow::Configuration dataFlowConfig, Query query,
  string queryName, string key, string value, string valueType
) {
  atmConfig = getAtmCfg(query) and
  dataFlowConfig = getDataFlowCfg(query) and
  queryName = query.getName() and
  ExtractEndpointData::endpoints(endpoint, atmConfig, queryName, key, value, valueType) and
  // only select endpoints that are either Sink or NotASink
  ExtractEndpointData::endpoints(endpoint, atmConfig, queryName, "sinkLabel", ["Sink", "NotASink"],
    "string") and
  // do not select endpoints filtered out by end-to-end evaluation
  ExtractEndpointData::endpoints(endpoint, atmConfig, queryName, "isExcludedFromEndToEndEvaluation",
    "false", "boolean") and
  // only select endpoints that can be part of a tainted flow
  ExtractEndpointData::endpoints(endpoint, atmConfig, queryName, "isConstantExpression", "false",
    "boolean")
}

query predicate tokenFeatures(
  DataFlow::Node endpoint, AtmConfig atmConfig, DataFlow::Configuration dataFlowConfig, Query query,
  string featureName, string featureValue
) {
  atmConfig = getAtmCfg(query) and
  dataFlowConfig = getDataFlowCfg(query) and
  endpoints(endpoint, atmConfig, dataFlowConfig, _, _, _, _, _) and
  ExtractEndpointData::tokenFeatures(endpoint, atmConfig, featureName, featureValue)
}
