/**
 * This module provides extensible predicates for defining MaD models.
 */

/**
 * Holds if a source model exists for the given parameters.
 */
extensible predicate sourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance
);

/**
 * Holds if a sink model exists for the given parameters.
 */
extensible predicate sinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance
);

/**
 * Holds if a summary model exists for the given parameters.
 */
extensible predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance
);

/**
 * Holds if a model exists indicating there is no flow for the given parameters.
 */
extensible predicate neutralModel(
  string namespace, string type, string name, string signature, string provenance
);
