/*
 * For internal use only.
 *
 * Provides an implementation of scoring alerts for use in adaptive threat modeling (ATM).
 */

private import javascript
private import BaseScoring
private import EndpointFeatures as EndpointFeatures
private import FeaturizationConfig
private import EndpointTypes

private string getACompatibleModelChecksum() {
  availableMlModels(result, "javascript", _, "atm-endpoint-scoring")
}

module ModelScoring {
  /**
   * A featurization config that only featurizes new candidate endpoints that are part of a flow
   * path.
   */
  class RelevantFeaturizationConfig extends FeaturizationConfig {
    RelevantFeaturizationConfig() { this = "RelevantFeaturization" }

    override DataFlow::Node getAnEndpointToFeaturize() {
      getCfg().isEffectiveSource(result) and any(DataFlow::Configuration cfg).hasFlow(result, _)
      or
      getCfg().isEffectiveSink(result) and any(DataFlow::Configuration cfg).hasFlow(_, result)
    }
  }

  DataFlow::Node getARequestedEndpoint() {
    result = any(FeaturizationConfig cfg).getAnEndpointToFeaturize()
  }

  private int getARequestedEndpointType() { result = any(EndpointType type).getEncoding() }

  predicate endpointScores(DataFlow::Node endpoint, int encodedEndpointType, float score) =
    scoreEndpoints(getARequestedEndpoint/0, EndpointFeatures::tokenFeatures/3,
      EndpointFeatures::getASupportedFeatureName/0, getARequestedEndpointType/0,
      getACompatibleModelChecksum/0)(endpoint, encodedEndpointType, score)
}

/**
 * Return ATM's confidence that `source` is a source for the given security query. This will be a
 * number between 0.0 and 1.0.
 */
private float getScoreForSource(DataFlow::Node source) {
  if getCfg().isKnownSource(source)
  then result = 1.0
  else (
    // This restriction on `source` has no semantic effect but improves performance.
    getCfg().isEffectiveSource(source) and
    ModelScoring::endpointScores(source, getCfg().getASourceEndpointType().getEncoding(), result)
  )
}

/**
 * Return ATM's confidence that `sink` is a sink for the given security query. This will be a
 * number between 0.0 and 1.0.
 */
private float getScoreForSink(DataFlow::Node sink) {
  if getCfg().isKnownSink(sink)
  then result = 1.0
  else (
    // This restriction on `sink` has no semantic effect but improves performance.
    getCfg().isEffectiveSink(sink) and
    ModelScoring::endpointScores(sink, getCfg().getASinkEndpointType().getEncoding(), result)
  )
}

class EndpointScoringResults extends ScoringResults {
  EndpointScoringResults() {
    this = "EndpointScoringResults" and exists(getACompatibleModelChecksum())
  }

  /**
   * Get ATM's confidence that a path between `source` and `sink` represents a security
   * vulnerability. This will be a number between 0.0 and 1.0.
   */
  override float getScoreForFlow(DataFlow::Node source, DataFlow::Node sink) {
    result = getScoreForSource(source) * getScoreForSink(sink)
  }

  /**
   * Get a string representing why ATM included the given source in the dataflow analysis.
   *
   * In general, there may be multiple reasons why ATM included the given source, in which case
   * this predicate should have multiple results.
   */
  pragma[inline]
  override string getASourceOrigin(DataFlow::Node source) {
    result = "known" and getCfg().isKnownSource(source)
    or
    result = "predicted" and getCfg().isEffectiveSource(source)
  }

  /**
   * Get a string representing why ATM included the given sink in the dataflow analysis.
   *
   * In general, there may be multiple reasons why ATM included the given sink, in which case
   * this predicate should have multiple results.
   */
  pragma[inline]
  override string getASinkOrigin(DataFlow::Node sink) {
    result = "known" and getCfg().isKnownSink(sink)
    or
    not getCfg().isKnownSink(sink) and
    result =
      "predicted (scores: " +
        concat(EndpointType type, float score |
          ModelScoring::endpointScores(sink, type.getEncoding(), score)
        |
          type.getDescription() + "=" + score.toString(), ", " order by type.getEncoding()
        ) + ")" and
    getCfg().isEffectiveSink(sink)
  }

  pragma[inline]
  override predicate shouldResultBeIncluded(DataFlow::Node source, DataFlow::Node sink) {
    if getCfg().isKnownSink(sink)
    then any()
    else (
      // This restriction on `sink` has no semantic effect but improves performance.
      getCfg().isEffectiveSink(sink) and
      exists(float sinkScore |
        ModelScoring::endpointScores(sink, getCfg().getASinkEndpointType().getEncoding(), sinkScore) and
        // Include the endpoint if (a) the query endpoint type scores higher than all other
        // endpoint types, or (b) the query endpoint type scores at least
        // 0.5 - (getCfg().getScoreCutoff() / 2).
        sinkScore >=
          [
            max(float s | ModelScoring::endpointScores(sink, _, s)),
            0.5 - getCfg().getScoreCutoff() / 2
          ]
      )
    )
  }
}

module Debugging {
  query predicate hopInputEndpoints(DataFlow::Node endpoint) {
    endpoint = ModelScoring::getARequestedEndpoint()
  }

  query predicate endpointScores = ModelScoring::endpointScores/3;

  query predicate shouldResultBeIncluded(DataFlow::Node source, DataFlow::Node sink) {
    any(ScoringResults scoringResults).shouldResultBeIncluded(source, sink) and
    any(DataFlow::Configuration cfg).hasFlow(source, sink)
  }
}
