/**
 * This module provides extensible predicates for defining MaD models.
 */

/**
 * Holds if a source model exists for the given parameters.
 */
extensible predicate actionsSourceModel(
  string action, string version, string output, string kind, string provenance
);

/**
 * Holds if a summary model exists for the given parameters.
 */
extensible predicate actionsSummaryModel(
  string action, string version, string input, string output, string kind, string provenance
);

/**
 * Holds if a sink model exists for the given parameters.
 */
extensible predicate actionsSinkModel(
  string action, string version, string input, string kind, string provenance
);
