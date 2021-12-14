/*
 * For internal use only.
 *
 * Provides shared scoring functionality for use in adaptive threat modeling (ATM).
 */

private import javascript
private import ATMConfig

external predicate availableMlModels(
  string modelChecksum, string modelLanguage, string modelName, string modelType
);

/** Get the ATM configuration. */
ATMConfig getCfg() { any() }

/**
 * This module provides functionality that takes an endpoint and provides an entity that encloses that
 * endpoint and is suitable for similarity analysis.
 */
module EndpointToEntity {
  private import CodeToFeatures

  /**
   * Get an entity enclosing the endpoint that is suitable for similarity analysis. In general,
   * this may associate multiple entities to a single endpoint.
   */
  DatabaseFeatures::Entity getAnEntityForEndpoint(DataFlow::Node endpoint) {
    DatabaseFeatures::entities(result, _, _, _, _, _, _, _, _) and
    result.getDefinedFunction() = endpoint.getContainer().getEnclosingContainer*()
  }
}

/**
 * This module provides functionality that takes an entity and provides effective endpoints within
 * that entity.
 *
 * We use the following terminology to describe endpoints:
 *
 * - The *candidate* endpoints are the set of data flow nodes that should be passed to the
 *   appropriate endpoint filter to produce the set of effective endpoints.
 *   When we have a model that beats the performance of the baseline, we will likely define the
 *   candidate endpoints based on the most confident predictions of the model.
 * - An *effective* endpoint is a candidate endpoint which passes through the endpoint filter.
 *   In other words, it is a candidate endpoint for which the `isEffectiveSink` (or
 *   `isEffectiveSource`) predicate defined in the `ATMConfig` instance in scope holds.
 */
module EntityToEffectiveEndpoint {
  private import CodeToFeatures

  /**
   * Returns endpoint candidates within the specified entities.
   *
   * The baseline implementation of this is that a candidate endpoint is any data flow node that is
   * enclosed within the specified entity.
   */
  private DataFlow::Node getABaselineEndpointCandidate(DatabaseFeatures::Entity entity) {
    result.getContainer().getEnclosingContainer*() = entity.getDefinedFunction()
  }

  /**
   * Get an effective source enclosed by the specified entity.
   *
   * N.B. This is _not_ an inverse of `EndpointToEntity::getAnEntityForEndpoint`: the effective
   * source may occur in a function defined within the specified entity.
   */
  DataFlow::Node getAnEffectiveSource(DatabaseFeatures::Entity entity) {
    result = getABaselineEndpointCandidate(entity) and
    getCfg().isEffectiveSource(result)
  }

  /**
   * Get an effective sink enclosed by the specified entity.
   *
   * N.B. This is _not_ an inverse of `EndpointToEntity::getAnEntityForEndpoint`: the effective
   * sink may occur in a function defined within the specified entity.
   */
  DataFlow::Node getAnEffectiveSink(DatabaseFeatures::Entity entity) {
    result = getABaselineEndpointCandidate(entity) and
    getCfg().isEffectiveSink(result)
  }
}

/**
 * Scoring information produced by a scoring model.
 *
 * Scoring models include embedding models and endpoint scoring models.
 */
abstract class ScoringResults extends string {
  bindingset[this]
  ScoringResults() { any() }

  /**
   * Get ATM's confidence that a path between `source` and `sink` represents a security
   * vulnerability. This will be a number between 0.0 and 1.0.
   */
  abstract float getScoreForFlow(DataFlow::Node source, DataFlow::Node sink);

  /**
   * Get a string representing why ATM included the given source in the dataflow analysis.
   *
   * In general, there may be multiple reasons why ATM included the given source, in which case
   * this predicate should have multiple results.
   */
  abstract string getASourceOrigin(DataFlow::Node source);

  /**
   * Get a string representing why ATM included the given sink in the dataflow analysis.
   *
   * In general, there may be multiple reasons why ATM included the given sink, in which case this
   * predicate should have multiple results.
   */
  abstract string getASinkOrigin(DataFlow::Node sink);

  /**
   * Indicates whether the flow from source to sink represents a result with
   * sufficiently high likelihood of being a true-positive.
   */
  pragma[inline]
  abstract predicate shouldResultBeIncluded(DataFlow::Node source, DataFlow::Node sink);
}
