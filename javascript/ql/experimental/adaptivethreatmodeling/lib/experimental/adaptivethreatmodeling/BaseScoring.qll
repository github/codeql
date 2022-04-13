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
AtmConfig getCfg() { any() }

/**
 * A string containing scoring information produced by a scoring model.
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
