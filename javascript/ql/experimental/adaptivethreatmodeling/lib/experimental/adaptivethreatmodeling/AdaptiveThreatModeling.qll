/*
 * For internal use only.
 *
 * Provides information about the results of boosted queries for use in adaptive threat modeling (ATM).
 */

private import javascript::DataFlow as DataFlow
import ATMConfig
private import BaseScoring
private import EndpointScoring as EndpointScoring

module ATM {
  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * This module contains informational predicates about the results returned by adaptive threat
   * modeling (ATM).
   */
  module ResultsInfo {
    /**
     * Indicates whether the flow from source to sink represents a result with
     * sufficiently high likelihood of being a true-positive.
     */
    pragma[inline]
    private predicate shouldResultBeIncluded(DataFlow::Node source, DataFlow::Node sink) {
      any(ScoringResults results).shouldResultBeIncluded(source, sink)
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Returns the score for the flow between the source `source` and the `sink` sink in the
     * boosted query.
     */
    pragma[inline]
    float getScoreForFlow(DataFlow::Node source, DataFlow::Node sink) {
      any(DataFlow::Configuration cfg).hasFlow(source, sink) and
      shouldResultBeIncluded(source, sink) and
      result = unique(float s | s = any(ScoringResults results).getScoreForFlow(source, sink))
    }

    /**
     * Pad a score returned from `getKnownScoreForFlow` to a particular length by adding a decimal
     * point if one does not already exist, and "0"s after that decimal point.
     *
     * Note that this predicate must itself define an upper bound on `length`, so that it has a
     * finite number of results. Currently this is defined as 12.
     */
    private string paddedScore(float score, int length) {
      // In this definition, we must restrict the values that `length` and `score` can take on so
      // that the predicate has a finite number of results.
      (score = getScoreForFlow(_, _) or score = 0) and
      length = result.length() and
      (
        // We need to make sure the padded score contains a "." so lexically sorting the padded
        // scores is equivalent to numerically sorting the scores.
        score.toString().charAt(_) = "." and
        result = score.toString()
        or
        not score.toString().charAt(_) = "." and
        result = score.toString() + "."
      )
      or
      result = paddedScore(score, length - 1) + "0" and
      length <= 12
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Return a string representing the score of the flow between `source` and `sink` in the
     * boosted query.
     *
     * The returned string is a fixed length, such that lexically sorting the strings returned by
     * this predicate gives the same sort order as numerically sorting the scores of the flows.
     */
    pragma[inline]
    string getScoreStringForFlow(DataFlow::Node source, DataFlow::Node sink) {
      exists(float score |
        score = getScoreForFlow(source, sink) and
        (
          // A length of 12 is equivalent to 10 decimal places.
          score.toString().length() >= 12 and
          result = score.toString().substring(0, 12)
          or
          score.toString().length() < 12 and
          result = paddedScore(score, 12)
        )
      )
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Indicates whether the flow from source to sink is likely to be reported by the base security
     * query.
     *
     * Currently this is a heuristic: it ignores potential differences in the definitions of
     * additional flow steps.
     */
    pragma[inline]
    predicate isFlowLikelyInBaseQuery(DataFlow::Node source, DataFlow::Node sink) {
      getCfg().isKnownSource(source) and getCfg().isKnownSink(sink)
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Get additional information about why ATM included the flow from source to sink as an alert.
     */
    pragma[inline]
    string getAdditionalAlertInfo(DataFlow::Node source, DataFlow::Node sink) {
      exists(string sourceOrigins, string sinkOrigins |
        sourceOrigins = concat(any(ScoringResults results).getASourceOrigin(source), ", ") and
        sinkOrigins = concat(any(ScoringResults results).getASinkOrigin(sink), ", ") and
        result =
          "[Source origins: " +
            any(string s | if sourceOrigins != "" then s = sourceOrigins else s = "unknown") +
            "; sink origins: " +
            any(string s | if sinkOrigins != "" then s = sinkOrigins else s = "unknown") + "]"
      )
    }
  }
}
