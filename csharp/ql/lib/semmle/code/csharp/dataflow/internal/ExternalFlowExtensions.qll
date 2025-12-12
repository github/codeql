/**
 * This module provides extensible predicates for defining MaD models.
 */

private import codeql.mad.static.ModelsAsData as SharedMaD

/**
 * Holds if a source model exists for the given parameters.
 */
extensible predicate sourceModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a sink model exists for the given parameters.
 */
extensible predicate sinkModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a barrier model exists for the given parameters.
 */
extensible predicate barrierModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a barrier guard model exists for the given parameters.
 */
extensible predicate barrierGuardModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string acceptingvalue, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a summary model exists for the given parameters.
 */
extensible predicate summaryModel(
  string namespace, string type, boolean subtypes, string name, string signature, string ext,
  string input, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a neutral model exists for the given parameters.
 */
extensible predicate neutralModel(
  string namespace, string type, string name, string signature, string kind, string provenance
);

module Extensions implements SharedMaD::ExtensionsSig {
  import ExternalFlowExtensions

  predicate namespaceGrouping(string group, string namespace) { none() }
}
