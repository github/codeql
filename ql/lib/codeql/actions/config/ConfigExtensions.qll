/**
 * This module provides extensible predicates for defining MaD models.
 */

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

/**
 * Holds for strings that match poisonable commands.
 */
extensible predicate poisonableCommandsDataModel(string regexp);

/**
 * Holds for strings that match poisonable local scripts.
 */
extensible predicate poisonableLocalScriptsDataModel(string regexp, int group);

/**
 * Holds for actions that can be poisoned through local files.
 */
extensible predicate poisonableActionsDataModel(string action);

