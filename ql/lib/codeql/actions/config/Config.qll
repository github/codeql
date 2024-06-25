import ConfigExtensions as Extensions

/**
 * MaD models for workflow details
 * Fields:
 *    - path: Path to the workflow file
 *    - trigger: Trigger for the workflow
 *    - job: Job name
 *    - secrets_source: Source of secrets
 *    - permissions: Permissions for the workflow
 *    - runner: Runner info for the workflow
 */
predicate workflowDataModel(
  string path, string trigger, string job, string secrets_source, string permissions, string runner
) {
  Extensions::workflowDataModel(path, trigger, job, secrets_source, permissions, runner)
}

/**
 * MaD models for repository details
 * Fields:
 *    - visibility: Visibility of the repository
 *    - default_branch_name: Default branch name
 */
predicate repositoryDataModel(string visibility, string default_branch_name) {
  Extensions::repositoryDataModel(visibility, default_branch_name)
}

/**
 * MaD models for context/trigger mapping
 * Fields:
 *    - trigger: Trigger for the workflow
 *    - context_prefix: Prefix for the context
 */
predicate contextTriggerDataModel(string trigger, string context_prefix) {
  Extensions::contextTriggerDataModel(trigger, context_prefix)
}

/**
 * MaD models for externally triggerable events
 * Fields:
 *    - event: Event name
 */
predicate externallyTriggerableEventsDataModel(string event) {
  Extensions::externallyTriggerableEventsDataModel(event)
}

/**
 * MaD models for poisonable commands 
 * Fields:
 *    - regexp: Regular expression for matching poisonable commands
 */
predicate poisonableCommandsDataModel(string regexp) {
  Extensions::poisonableCommandsDataModel(regexp)
}

/**
 * MaD models for poisonable local scripts
 * Fields:
 *    - regexp: Regular expression for matching poisonable local scripts
 *    - group: Script capture group number for the regular expression
 */
predicate poisonableLocalScriptsDataModel(string regexp, int group) {
  Extensions::poisonableLocalScriptsDataModel(regexp, group)
}

/**
 * MaD models for poisonable actions
 * Fields:
 *    - action: action name
 */
predicate poisonableActionsDataModel(string action) {
  Extensions::poisonableActionsDataModel(action)
}
