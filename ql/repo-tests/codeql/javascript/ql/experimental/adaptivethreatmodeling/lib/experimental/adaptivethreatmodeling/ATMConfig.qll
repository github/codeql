/*
 * For internal use only.
 *
 * Configures boosting for adaptive threat modeling (ATM).
 */

private import javascript as raw
import EndpointTypes

/**
 * EXPERIMENTAL. This API may change in the future.
 *
 * A configuration class for defining known endpoints and endpoint filters for adaptive threat
 * modeling (ATM). Each boosted query must define its own extension of this abstract class.
 *
 * A configuration defines a set of known sources (`isKnownSource`) and sinks (`isKnownSink`).
 * It must also define a sink endpoint filter (`isEffectiveSink`) that filters candidate sinks
 * predicted by the machine learning model to a set of effective sinks.
 *
 * To get started with ATM, you can copy-paste an implementation of the relevant predicates from a
 * `DataFlow::Configuration` or `TaintTracking::Configuration` class for a standard security query.
 * For example, for SQL injection you can start by defining the `isKnownSource` and `isKnownSink`
 * predicates in the ATM configuration by copying and pasting the implementations of `isSource` and
 * `isSink` from `SqlInjection::Configuration`.
 *
 * Note that if the security query configuration defines additional edges beyond the standard data
 * flow edges, such as `NosqlInjection::Configuration`, you may need to replace the definition of
 * `isAdditionalFlowStep` with a more generalised definition of additional edges. See
 * `NosqlInjectionATM.qll` for an example of doing this.
 */
abstract class ATMConfig extends string {
  bindingset[this]
  ATMConfig() { any() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `source` is a known source of flow.
   */
  predicate isKnownSource(raw::DataFlow::Node source) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `sink` is a known sink of flow.
   */
  predicate isKnownSink(raw::DataFlow::Node sink) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the candidate source `candidateSource` predicted by the machine learning model should be
   * an effective source, i.e. one considered as a possible source of flow in the boosted query.
   */
  predicate isEffectiveSource(raw::DataFlow::Node candidateSource) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the candidate sink `candidateSink` predicted by the machine learning model should be
   * an effective sink, i.e. one considered as a possible sink of flow in the boosted query.
   */
  predicate isEffectiveSink(raw::DataFlow::Node candidateSink) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the candidate sink `candidateSink` predicted by the machine learning model should be
   * an effective sink that overrides the score provided by the machine learning model with the
   * score `score` for reason `why`. The effective sinks identified by this predicate MUST be a
   * subset of those identified by the `isEffectiveSink` predicate.
   *
   * For example, in the ATM external API query, we use this method to ensure the ATM external API
   * query produces the same results as the standard external API query, but assigns flows
   * involving sinks that are filtered out by the endpoint filters a score of 0.
   *
   * This predicate can be phased out once we no longer need to rely on predicates like
   * `paddedScore` in the ATM CodeQL libraries to add scores to alert messages in a way that works
   * with lexical sort orders.
   */
  predicate isEffectiveSinkWithOverridingScore(
    raw::DataFlow::Node candidateSink, float score, string why
  ) {
    none()
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Get an endpoint type for the sources of this query. A query may have multiple applicable
   * endpoint types for its sources.
   */
  EndpointType getASourceEndpointType() { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Get an endpoint type for the sinks of this query. A query may have multiple applicable
   * endpoint types for its sinks.
   */
  EndpointType getASinkEndpointType() { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Specifies the default cut-off value that controls how many alerts are produced.
   * The cut-off value must be in the range [0,1].
   * A cut-off value of 0 only produces alerts that are likely true-positives.
   * A cut-off value of 1 produces all alerts including those that are likely false-positives.
   */
  float getScoreCutoff() { result = 0.0 }
}
