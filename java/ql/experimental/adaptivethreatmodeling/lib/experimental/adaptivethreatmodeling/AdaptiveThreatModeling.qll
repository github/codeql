/**
 * For internal use only.
 *
 * Provides information about the results of boosted queries for use in adaptive threat modeling (ATM).
 */

private import java as java
private import semmle.code.java.dataflow.TaintTracking
import ATMConfig

module ATM {
  /** Get the ATM configuration. */
  AtmConfig getCfg() { any() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * This module contains informational predicates about the results returned by adaptive threat
   * modeling (ATM).
   */
  module ResultsInfo {
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
  }
}
