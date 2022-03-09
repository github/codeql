/*
 * For internal use only.
 *
 * Library code for training and evaluation data we can use to train ML models for ML-powered
 * queries.
 */

import javascript
import Exclusions as Exclusions
import evaluation.EndToEndEvaluation as EndToEndEvaluation
import experimental.adaptivethreatmodeling.ATMConfig
import experimental.adaptivethreatmodeling.CoreKnowledge as CoreKnowledge
import experimental.adaptivethreatmodeling.EndpointFeatures as EndpointFeatures
import experimental.adaptivethreatmodeling.EndpointScoring as EndpointScoring
import experimental.adaptivethreatmodeling.EndpointTypes
import experimental.adaptivethreatmodeling.FilteringReasons
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.StoredXssATM as StoredXssATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM
import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomATM
import Labels
import NoFeaturizationRestrictionsConfig
import Queries

/** Gets the ATM configuration object for the specified query. */
AtmConfig getAtmCfg(Query query) {
  query instanceof NosqlInjectionQuery and
  result instanceof NosqlInjectionATM::NosqlInjectionAtmConfig
  or
  query instanceof SqlInjectionQuery and result instanceof SqlInjectionATM::SqlInjectionAtmConfig
  or
  query instanceof StoredXssQuery and result instanceof StoredXssATM::StoredXssATMConfig
  or
  query instanceof TaintedPathQuery and result instanceof TaintedPathATM::TaintedPathATMConfig
  or
  query instanceof XssQuery and result instanceof XssATM::DomBasedXssATMConfig
  or
  query instanceof XssThroughDomQuery and result instanceof XssThroughDomATM::XssThroughDOMATMConfig
}

/** DEPRECATED: Alias for getAtmCfg */
deprecated ATMConfig getATMCfg(Query query) { result = getAtmCfg(query) }

/** Gets the ATM data flow configuration for the specified query. */
DataFlow::Configuration getDataFlowCfg(Query query) {
  query instanceof NosqlInjectionQuery and result instanceof NosqlInjectionATM::Configuration
  or
  query instanceof SqlInjectionQuery and result instanceof SqlInjectionATM::Configuration
  or
  query instanceof TaintedPathQuery and result instanceof TaintedPathATM::Configuration
  or
  query instanceof XssQuery and result instanceof XssATM::Configuration
  or
  query instanceof StoredXssQuery and result instanceof StoredXssATM::Configuration
  or
  query instanceof XssThroughDomQuery and result instanceof XssThroughDomATM::Configuration
}

/** Gets a known sink for the specified query. */
private DataFlow::Node getASink(Query query) {
  getAtmCfg(query).isKnownSink(result) and
  // Only consider the source code for the project being analyzed.
  exists(result.getFile().getRelativePath())
}

/** Gets a data flow node that is known not to be a sink for the specified query. */
private DataFlow::Node getANotASink(NotASinkReason reason) {
  CoreKnowledge::isOtherModeledArgument(result, reason) and
  // Some endpoints can be assigned both a `NotASinkReason` and a `LikelyNotASinkReason`. We
  // consider these endpoints to be `LikelyNotASink`, therefore this line excludes them from the
  // definition of `NotASink`.
  not CoreKnowledge::isOtherModeledArgument(result, any(LikelyNotASinkReason t)) and
  not result = getASink(_) and
  // Only consider the source code for the project being analyzed.
  exists(result.getFile().getRelativePath())
}

/**
 * Gets a data flow node whose label is unknown for the specified query.
 *
 * In other words, this is an endpoint that is not `Sink`, `NotASink`, or `LikelyNotASink` for the
 * specified query.
 */
private DataFlow::Node getAnUnknown(Query query) {
  getAtmCfg(query).isEffectiveSink(result) and
  not result = getASink(query) and
  // Only consider the source code for the project being analyzed.
  exists(result.getFile().getRelativePath())
}

/** Gets the query-specific sink label for the given endpoint, if such a label exists. */
private EndpointLabel getSinkLabelForEndpoint(DataFlow::Node endpoint, Query query) {
  endpoint = getASink(query) and result instanceof SinkLabel
  or
  endpoint = getANotASink(_) and result instanceof NotASinkLabel
  or
  endpoint = getAnUnknown(query) and result instanceof UnknownLabel
}

/** Gets an endpoint that should be extracted. */
DataFlow::Node getAnEndpoint(Query query) { exists(getSinkLabelForEndpoint(result, query)) }

/**
 * Endpoints and associated metadata.
 *
 * Note that we draw a distinction between _features_, that are provided to the model at training
 * and query time, and _metadata_, that is only provided to the model at training time.
 *
 * Internal: See the design document for
 * [extensible extraction queries](https://docs.google.com/document/d/1g3ci2Nf1hGMG6ZUP0Y4PqCy_8elcoC_dhBvgTxdAWpg)
 * for technical information about the design of this predicate.
 */
predicate endpoints(
  DataFlow::Node endpoint, string queryName, string key, string value, string valueType
) {
  exists(Query query |
    // Only provide metadata for labelled endpoints, since we do not extract all endpoints.
    endpoint = getAnEndpoint(query) and
    queryName = query.getName() and
    (
      // Holds if there is a taint flow path from a known source to the endpoint
      key = "hasFlowFromSource" and
      (
        if FlowFromSource::hasFlowFromSource(endpoint, query)
        then value = "true"
        else value = "false"
      ) and
      valueType = "boolean"
      or
      // Constant expressions always evaluate to a constant primitive value. Therefore they can't ever
      // appear in an alert, making them less interesting training examples.
      key = "isConstantExpression" and
      (if endpoint.asExpr() instanceof ConstantExpr then value = "true" else value = "false") and
      valueType = "boolean"
      or
      // Holds if alerts involving the endpoint are excluded from the end-to-end evaluation.
      key = "isExcludedFromEndToEndEvaluation" and
      (if Exclusions::isFileExcluded(endpoint.getFile()) then value = "true" else value = "false") and
      valueType = "boolean"
      or
      // The label for this query, considering the endpoint as a sink.
      key = "sinkLabel" and
      value = getSinkLabelForEndpoint(endpoint, query).getEncoding() and
      valueType = "string"
      or
      // The reason, or reasons, why the endpoint was labeled NotASink for this query.
      key = "notASinkReason" and
      exists(FilteringReason reason |
        endpoint = getANotASink(reason) and
        value = reason.getDescription()
      ) and
      valueType = "string"
    )
  )
}

/**
 * `EndpointFeatures::tokenFeatures` has no results when `featureName` is absent for the endpoint
 * `endpoint`. To preserve compatibility with the data pipeline, this relation will instead set
 * `featureValue` to the empty string in this case.
 */
predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  endpoints(endpoint, _, _, _, _) and
  (
    EndpointFeatures::tokenFeatures(endpoint, featureName, featureValue)
    or
    // Performance note: this creates a Cartesian product between `endpoint` and `featureName`.
    featureName = EndpointFeatures::getASupportedFeatureName() and
    not exists(string value | EndpointFeatures::tokenFeatures(endpoint, featureName, value)) and
    featureValue = ""
  )
}

module FlowFromSource {
  predicate hasFlowFromSource(DataFlow::Node endpoint, Query q) {
    exists(Configuration cfg | cfg.getQuery() = q | cfg.hasFlow(_, endpoint))
  }

  /**
   * A data flow configuration that replicates the data flow configuration for a specific query, but
   * replaces the set of sinks with the set of endpoints we're extracting.
   *
   * We use this to find out when there is flow to a particular endpoint from a known source.
   *
   * This configuration behaves in a very similar way to the `ForwardExploringConfiguration` class
   * from the CodeQL standard libraries for JavaScript.
   */
  private class Configuration extends DataFlow::Configuration {
    Query q;

    Configuration() { this = getDataFlowCfg(q) }

    Query getQuery() { result = q }

    /** The sinks are the endpoints we're extracting. */
    override predicate isSink(DataFlow::Node sink) { sink = getAnEndpoint(q) }

    /** The sinks are the endpoints we're extracting. */
    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
      sink = getAnEndpoint(q)
    }
  }
}
