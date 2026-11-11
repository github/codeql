import codeql.actions.config.ConfigExtensions

query predicate workflowDataModels(
  string path, string trigger, string job, string secrets_source, string permissions, string runner
) {
  workflowDataModel(path, trigger, job, secrets_source, permissions, runner)
}

query predicate repositoryDataModels(string visibility, string default_branch_name) {
  repositoryDataModel(visibility, default_branch_name)
}

query predicate contextTriggerDataModels(string trigger, string context_prefix) {
  contextTriggerDataModel(trigger, context_prefix)
}

query predicate externallyTriggerableEventsDataModels(string event) {
  externallyTriggerableEventsDataModel(event)
}

query predicate poisonableCommandsDataModels(string regexp) { poisonableCommandsDataModel(regexp) }

query predicate poisonableLocalScriptsDataModels(string regexp, int group) {
  poisonableLocalScriptsDataModel(regexp, group)
}

query predicate poisonableActionsDataModels(string action) { poisonableActionsDataModel(action) }

query predicate untrustedEventPropertiesDataModels(string property, string kind) {
  untrustedEventPropertiesDataModel(property, kind)
}

query predicate argumentInjectionSinksDataModels(
  string regexp, int command_group, int argument_group
) {
  argumentInjectionSinksDataModel(regexp, command_group, argument_group)
}

query predicate vulnerableActionsDataModels(
  string action, string vulnerable_version, string vulnerable_sha, string fixed_version
) {
  vulnerableActionsDataModel(action, vulnerable_version, vulnerable_sha, fixed_version)
}

query predicate immutableActionsDataModels(string action) { immutableActionsDataModel(action) }

query predicate trustedActionsOwnerDataModels(string owner) { trustedActionsOwnerDataModel(owner) }

query predicate untrustedGitCommandDataModels(string cmd_regex, string flag) {
  untrustedGitCommandDataModel(cmd_regex, flag)
}

query predicate untrustedGhCommandDataModels(string cmd_regex, string flag) {
  untrustedGhCommandDataModel(cmd_regex, flag)
}

query predicate actionsPermissionsDataModels(string action, string permission) {
  actionsPermissionsDataModel(action, permission)
}

query predicate enabledDeploymentEnvironmentDataModels(string name) {
  enabledDeploymentEnvironmentDataModel(name)
}
