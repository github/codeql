/**
 * This module provides extensible predicates for defining MaD models.
 */

private import codeql.mad.static.ModelsAsData as SharedMaD

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
 * Holds if a barrier model exists for the given parameters.
 */
extensible predicate barrierModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string output, string kind, string provenance, QlBuiltins::ExtensionId madId
);

/**
 * Holds if a barrier guard model exists for the given parameters.
 */
extensible predicate barrierGuardModel(
  string package, string type, boolean subtypes, string name, string signature, string ext,
  string input, string acceptingvalue, string kind, string provenance, QlBuiltins::ExtensionId madId
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
 * Holds if the package `package` is part of the group `group`.
 */
extensible predicate packageGrouping(string group, string package);

module Extensions implements SharedMaD::ExtensionsSig {
  import ExternalFlowExtensions

  predicate namespaceGrouping = packageGrouping/2;
}
