/**
 * This module provides extensible predicates for defining MaD models.
 */

/**
 * Holds if a source model exists for the given parameters.
 */
extensible predicate sourceModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a sink model exists for the given parameters.
 */
extensible predicate sinkModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a summary model exists for the given parameters.
 */
extensible predicate summaryModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a neutral model exists for the given parameters.
 */
extensible predicate neutralModel(
  string package, string type, string name, string signature, string kind, string provenance
);

/**
 * INTERNAL: Do not use.
 *
 * DEPRECATED: This predicate is only intended for adding models used by experimental queries.
 * This predicate will be deleted in the future.
 *
 * Holds if an experimental source model exists for the given parameters.
 * This is only for experimental queries.
 */
extensible predicate experimentalSourceModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, string filter, QlBuiltins::ExtensionId madId
);

/**
 * INTERNAL: Do not use.
 *
 * DEPRECATED: This predicate is only intended for adding models used by experimental queries.
 * This predicate will be deleted in the future.
 *
 * Holds if an experimental sink model exists for the given parameters.
 * This is only for experimental queries.
 */
extensible predicate experimentalSinkModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, string filter, QlBuiltins::ExtensionId madId
);

/**
 * INTERNAL: Do not use.
 *
 * DEPRECATED: This predicate is only intended for adding models used by experimental queries.
 * This predicate will be deleted in the future.
 *
 * Holds if an experimental summary model exists for the given parameters.
 * This is only for experimental queries.
 */
extensible predicate experimentalSummaryModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, string filter,
  QlBuiltins::ExtensionId madId
);
