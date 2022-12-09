/**
 * For internal use only.
 *
 * Provides an implementation of scoring alerts for use in adaptive threat modeling (ATM).
 */

private import javascript
private import BaseScoring
private import EndpointFeatures as EndpointFeatures
private import FeaturizationConfig
private import EndpointTypes
private import ModelPrompt as ModelPrompt

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

  predicate getEndpointPrompt(DataFlow::Node node, string prompt) {
    node = getARequestedEndpoint() and
    prompt = ModelPrompt::ModelPrompt::getPrompt(node)
  }

  predicate endpointScores(DataFlow::Node endpoint, int encodedEndpointType, float score) {
    endpoint = getSampleFromSampleRate(0.1) and
    exists(EndpointType endpointType |
      endpointType.getEncoding() = encodedEndpointType and
      internalEnpointScores(endpoint, endpointType.getDescription()) and
      score = 1.0
    )
  }

  bindingset[rate]
  DataFlow::Node getSampleFromSampleRate(float rate) {
    exists(int r |
      result =
        rank[r](DataFlow::Node n, string path, int a, int b, int c, int d |
          n.asExpr().getLocation().hasLocationInfo(path, a, b, c, d)
        |
          n order by path, a, b, c, d
        ) and
      r % (1 / rate).ceil() = 0
    )
  }

  pragma[inline]
  predicate internalEnpointScores(DataFlow::Node endpoint, string prediction) =
    remoteScoreEndpoints(getEndpointPrompt/2)(endpoint, prediction)

  // For debugging queries, don't limit these to effective sinks:
  predicate getEndpointPromptForAnyEndpoint(DataFlow::Node node, string prompt) {
    prompt = ModelPrompt::ModelPrompt::getPrompt(node)
  }

  pragma[inline]
  predicate internalEnpointScoresForAnyEndpoint(DataFlow::Node endpoint, string prediction) =
    remoteScoreEndpoints(getEndpointPromptForAnyEndpoint/2)(endpoint, prediction)
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
  EndpointScoringResults() { this = "EndpointScoringResults" }

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
    exists(source) and
    if getCfg().isKnownSink(sink)
    then any()
    else (
      // This restriction on `sink` has no semantic effect but improves performance.
      getCfg().isEffectiveSink(sink) and
      exists(float sinkScore |
        ModelScoring::endpointScores(sink, getCfg().getASinkEndpointType().getEncoding(), sinkScore)
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
