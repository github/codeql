/*
 * For internal use only.
 *
 * Provides an implementation of scoring alerts for use in adaptive threat modeling (ATM).
 */

private import javascript
import BaseScoring
import CodeToFeatures
import EndpointFeatures as EndpointFeatures
import EndpointTypes

private string getACompatibleModelChecksum() {
  availableMlModels(result, "javascript", _, "atm-endpoint-scoring")
}

/**
 * The maximum number of AST nodes an entity containing an endpoint should have before we should
 * choose a smaller entity to represent the endpoint.
 *
 * This is intended to represent a balance in terms of the amount of context we provide to the
 * model: we don't want the function to be too small, because then it doesn't contain very much
 * context and miss useful information, but also we don't want it to be too large, because then
 * there's likely to be a lot of irrelevant or very loosely related context.
 */
private int getMaxNumAstNodes() { result = 1024 }

/**
 * Returns the number of AST nodes contained within the specified entity.
 */
private int getNumAstNodesInEntity(DatabaseFeatures::Entity entity) {
  // Restrict the values `entity` can take on
  entity = EndpointToEntity::getAnEntityForEndpoint(_) and
  result =
    count(DatabaseFeatures::AstNode astNode | DatabaseFeatures::astNodes(entity, _, _, astNode, _))
}

/**
 * Get a single entity to use as the representative entity for the endpoint.
 *
 * We try to use the largest entity containing the endpoint that's below the AST node limit defined
 * in `getMaxNumAstNodes`. In the event of a tie, we use the entity that appears first within the
 * source archive.
 *
 * If no entities are smaller than the AST node limit, then we use the smallest entity containing
 * the endpoint.
 */
DatabaseFeatures::Entity getRepresentativeEntityForEndpoint(DataFlow::Node endpoint) {
  // Check whether there's an entity containing the endpoint that's smaller than the AST node limit.
  if
    getNumAstNodesInEntity(EndpointToEntity::getAnEntityForEndpoint(endpoint)) <=
      getMaxNumAstNodes()
  then
    // Use the largest entity smaller than the AST node limit, resolving ties using the entity that
    // appears first in the source archive.
    result =
      min(DatabaseFeatures::Entity entity, int numAstNodes, Location l |
        entity = EndpointToEntity::getAnEntityForEndpoint(endpoint) and
        numAstNodes = getNumAstNodesInEntity(entity) and
        numAstNodes <= getMaxNumAstNodes() and
        l = entity.getLocation()
      |
        entity
        order by
          numAstNodes desc, l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
      )
  else
    // Use the smallest entity, resolving ties using the entity that
    // appears first in the source archive.
    result =
      min(DatabaseFeatures::Entity entity, int numAstNodes, Location l |
        entity = EndpointToEntity::getAnEntityForEndpoint(endpoint) and
        numAstNodes = getNumAstNodesInEntity(entity) and
        l = entity.getLocation()
      |
        entity
        order by
          numAstNodes, l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
      )
}

module ModelScoring {
  /**
   * A featurization config that only featurizes new candidate endpoints that are part of a flow
   * path.
   */
  class RelevantFeaturizationConfig extends EndpointFeatures::FeaturizationConfig {
    RelevantFeaturizationConfig() { this = "RelevantFeaturization" }

    override DataFlow::Node getAnEndpointToFeaturize() {
      getCfg().isEffectiveSource(result) and any(DataFlow::Configuration cfg).hasFlow(result, _)
      or
      getCfg().isEffectiveSink(result) and any(DataFlow::Configuration cfg).hasFlow(_, result)
    }
  }

  DataFlow::Node getARequestedEndpoint() {
    result = any(EndpointFeatures::FeaturizationConfig cfg).getAnEndpointToFeaturize()
  }

  private int getARequestedEndpointType() { result = any(EndpointType type).getEncoding() }

  predicate endpointScores(DataFlow::Node endpoint, int encodedEndpointType, float score) =
    scoreEndpoints(getARequestedEndpoint/0, getARequestedEndpointType/0,
      EndpointFeatures::tokenFeatures/3, getACompatibleModelChecksum/0)(endpoint,
      encodedEndpointType, score)
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
  else
    if getCfg().isEffectiveSinkWithOverridingScore(sink, result, _)
    then any()
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
    getCfg().isEffectiveSinkWithOverridingScore(sink, _, result)
    or
    not getCfg().isKnownSink(sink) and
    not getCfg().isEffectiveSinkWithOverridingScore(sink, _, _) and
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
    else
      if getCfg().isEffectiveSinkWithOverridingScore(sink, _, _)
      then
        exists(float score |
          getCfg().isEffectiveSinkWithOverridingScore(sink, score, _) and
          score >= getCfg().getScoreCutoff()
        )
      else (
        // This restriction on `sink` has no semantic effect but improves performance.
        getCfg().isEffectiveSink(sink) and
        exists(float sinkScore |
          ModelScoring::endpointScores(sink, getCfg().getASinkEndpointType().getEncoding(),
            sinkScore) and
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
