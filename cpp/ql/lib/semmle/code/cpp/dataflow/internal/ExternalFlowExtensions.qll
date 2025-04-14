/**
 * This module provides extensible predicates for defining MaD models.
 */

/**
 * Holds if an external source model exists for the given parameters.
 */
extensible predicate sourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if an external sink model exists for the given parameters.
 */
extensible predicate sinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if an external summary model exists for the given parameters.
 */
extensible predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);
