/*
 * For internal use only.
 *
 * Configures boosting for adaptive threat modeling (ATM).
 */

private import javascript as JS
import EndpointTypes
import EndpointCharacteristics as EndpointCharacteristics

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
abstract class AtmConfig extends JS::TaintTracking::Configuration {
  bindingset[this]
  AtmConfig() { any() }

  /**
   * Holds if `source` is a relevant taint source. When sources are not boosted, `isSource` is equivalent to
   * `isKnownSource` (i.e there are no "effective" sources to be classified by an ML model).
   */
  override predicate isSource(JS::DataFlow::Node source) { this.isKnownSource(source) }

  /**
   * Holds if `sink` is a known taint sink or an "effective" sink (a candidate to be classified by an ML model).
   */
  override predicate isSink(JS::DataFlow::Node sink) {
    this.isKnownSink(sink) or this.isEffectiveSink(sink)
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `source` is a known source of flow.
   */
  predicate isKnownSource(JS::DataFlow::Node source) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `sink` is a known sink of flow.
   */
  final predicate isKnownSink(JS::DataFlow::Node sink) {
    // If the list of characteristics includes positive indicators with maximal confidence for this class, then it's a
    // known sink for the class.
    exists(EndpointCharacteristics::EndpointCharacteristic characteristic |
      characteristic.getEndpoints(sink) and
      characteristic
          .getImplications(this.getASinkEndpointType(), true, characteristic.maximalConfidence())
    )
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the candidate source `candidateSource` predicted by the machine learning model should be
   * an effective source, i.e. one considered as a possible source of flow in the boosted query.
   */
  predicate isEffectiveSource(JS::DataFlow::Node candidateSource) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the candidate sink `candidateSink` predicted by the machine learning model should be
   * an effective sink, i.e. one considered as a possible sink of flow in the boosted query.
   */
  predicate isEffectiveSink(JS::DataFlow::Node candidateSink) {
    not exists(this.getAReasonSinkExcluded(candidateSink))
  }

  final EndpointCharacteristics::EndpointCharacteristic getAReasonSinkExcluded(
    JS::DataFlow::Node candidateSink
  ) {
    // An endpoint is an effective sink if it has neither standard endpoint filter characteristics nor endpoint filter
    // characteristics that are specific to this sink type.
    // TODO: Experiment with excluding all endpoints that have a medium- or high-confidence characteristic that implies
    // they're not sinks for this sink type (or not sinks for any sink type), not just the EndpointFilterCharacteristics.
    exists(EndpointCharacteristics::StandardEndpointFilterCharacteristic standardFilter |
      standardFilter.getEndpoints(candidateSink) and
      result = standardFilter
    )
    or
    exists(EndpointCharacteristics::EndpointFilterCharacteristic specificFilter |
      specificFilter.getEndpoints(candidateSink) and
      specificFilter.getImplications(this.getASinkEndpointType(), false, _) and
      result = specificFilter
    )
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
  abstract EndpointType getASinkEndpointType();

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

/** DEPRECATED: Alias for AtmConfig */
deprecated class ATMConfig = AtmConfig;
