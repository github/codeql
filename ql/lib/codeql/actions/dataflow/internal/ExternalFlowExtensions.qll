/**
 * This module provides extensible predicates for defining MaD models.
 */

/**
 * Holds if a source model exists for the given parameters.
 */
extensible predicate sourceModel(
  string action, string version, string output, string kind, string provenance
);

/**
 * Holds if a summary model exists for the given parameters.
 */
extensible predicate summaryModel(
  string action, string version, string input, string output, string kind, string provenance
);

/**
 * Holds if a sink model exists for the given parameters.
 */
extensible predicate sinkModel(
  string action, string version, string input, string kind, string provenance
);

extensible predicate workflowDataModel(
  string path, string trigger, string job, string secrets_source, string permissions,
  string runner
);

extensible predicate repositoryDataModel(
  string visibility, string default_branch_name
);
