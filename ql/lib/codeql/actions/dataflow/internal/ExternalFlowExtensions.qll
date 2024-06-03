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

/**
 * Holds if workflow data model exists for the given parameters.
 */
extensible predicate workflowDataModel(
  string path, string trigger, string job, string secrets_source, string permissions, string runner
);

/**
 * Holds if repository data model exists for the given parameters.
 */
extensible predicate repositoryDataModel(string visibility, string default_branch_name);

/**
 * Holds if a context expression starting with context_prefix is available for a given trigger.
 */
extensible predicate contextTriggerDataModel(string trigger, string context_prefix);

/**
 * Holds if a given trigger event can be fired by an external actor.
 */
extensible predicate externallyTriggerableEventsDataModel(string event);
