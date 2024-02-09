/**
 * This module provides extensible predicates for defining MaD models.
 */

/**
 * Holds if a source model exists for the given parameters.
 */
extensible predicate sourceModel(string action, string version, string output, string kind);

/**
 * Holds if a summary model exists for the given parameters.
 */
extensible predicate summaryModel(
  string action, string version, string input, string output, string kind
);

/**
 * Holds if a sink model exists for the given parameters.
 */
extensible predicate sinkModel(string action, string version, string input, string kind);
