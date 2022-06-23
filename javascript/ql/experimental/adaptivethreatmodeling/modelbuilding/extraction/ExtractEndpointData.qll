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
import Labels
import NoFeaturizationRestrictionsConfig
import Queries

/** Gets a known sink for the specified query. */
private DataFlow::Node getASink(AtmConfig atmConfig) {
  atmConfig.isKnownSink(result) and
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
private DataFlow::Node getAnUnknown(AtmConfig atmConfig) {
  atmConfig.isEffectiveSink(result) and
  // Effective sinks should exclude sinks but this is a defensive requirement
  not result = getASink(atmConfig) and
  // Effective sinks should exclude NotASink but for some queries (e.g. Xss) this is currently not always the case and
  // so this is a defensive requirement
  not result = getANotASink(_) and
  // Only consider the source code for the project being analyzed.
  exists(result.getFile().getRelativePath())
}

/** Gets the query-specific sink label for the given endpoint, if such a label exists. */
private EndpointLabel getSinkLabelForEndpoint(DataFlow::Node endpoint, AtmConfig atmConfig) {
  endpoint = getASink(atmConfig) and result instanceof SinkLabel
  or
  endpoint = getANotASink(_) and result instanceof NotASinkLabel
  or
  endpoint = getAnUnknown(atmConfig) and result instanceof UnknownLabel
}

/** Gets an endpoint that should be extracted. */
DataFlow::Node getAnEndpoint(AtmConfig atmConfig) {
  exists(getSinkLabelForEndpoint(result, atmConfig))
}

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
  DataFlow::Node endpoint, AtmConfig atmConfig, string queryName, string key, string value,
  string valueType
) {
  exists(Query query |
    // Only provide metadata for labelled endpoints, since we do not extract all endpoints.
    endpoint = getAnEndpoint(atmConfig) and
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
      value = getSinkLabelForEndpoint(endpoint, atmConfig).getEncoding() and
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
predicate tokenFeatures(
  DataFlow::Node endpoint, AtmConfig atmConfig, string featureName, string featureValue
) {
  endpoints(endpoint, atmConfig, _, _, _, _) and
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
    AtmConfig atmConfig;
    DataFlow::Configuration dataFlowConfig;

    Configuration() { this = dataFlowConfig }

    Query getQuery() { result = q }

    /** The sinks are the endpoints we're extracting. */
    override predicate isSink(DataFlow::Node sink) { sink = getAnEndpoint(atmConfig) }

    /** The sinks are the endpoints we're extracting. */
    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
      sink = getAnEndpoint(atmConfig) and exists(lbl)
    }
  }
}
