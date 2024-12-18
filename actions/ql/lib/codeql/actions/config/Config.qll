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

private string commandLauncher() { result = ["", "sudo\\s+", "su\\s+", "xvfb-run\\s+"] }

/**
 * MaD models for poisonable commands
 * Fields:
 *    - regexp: Regular expression for matching poisonable commands
 */
predicate poisonableCommandsDataModel(string regexp) {
  exists(string sub_regexp |
    Extensions::poisonableCommandsDataModel(sub_regexp) and
    regexp = commandLauncher() + sub_regexp + ".*"
  )
}

/**
 * MaD models for poisonable local scripts
 * Fields:
 *    - regexp: Regular expression for matching poisonable local scripts
 *    - group: Script capture group number for the regular expression
 */
predicate poisonableLocalScriptsDataModel(string regexp, int command_group) {
  exists(string sub_regexp |
    Extensions::poisonableLocalScriptsDataModel(sub_regexp, command_group) and
    regexp = commandLauncher() + sub_regexp + ".*"
  )
}

/**
 * MaD models for arguments to commands that execute the given argument.
 * Fields:
 *    - regexp: Regular expression for matching argument injections.
 *    - command_group: capture group for the command.
 *    - argument_group: capture group for the argument.
 */
predicate argumentInjectionSinksDataModel(string regexp, int command_group, int argument_group) {
  exists(string sub_regexp |
    Extensions::argumentInjectionSinksDataModel(sub_regexp, command_group, argument_group) and
    regexp = commandLauncher() + sub_regexp
  )
}

/**
 * MaD models for poisonable actions
 * Fields:
 *    - action: action name
 */
predicate poisonableActionsDataModel(string action) {
  Extensions::poisonableActionsDataModel(action)
}

/**
 * MaD models for event properties that can be user-controlled.
 * Fields:
 *    - property: event property
 *    - kind: property kind
 */
predicate untrustedEventPropertiesDataModel(string property, string kind) {
  Extensions::untrustedEventPropertiesDataModel(property, kind)
}

/**
 * MaD models for vulnerable actions
 * Fields:
 *    - action: action name
 *    - vulnerable_version: vulnerable version
 *    - vulnerable_sha: vulnerable sha
 *    - fixed_version: fixed version
 */
predicate vulnerableActionsDataModel(
  string action, string vulnerable_version, string vulnerable_sha, string fixed_version
) {
  Extensions::vulnerableActionsDataModel(action, vulnerable_version, vulnerable_sha, fixed_version)
}

/**
 * MaD models for immutable actions
 * Fields:
 *    - action: action name
 */
predicate immutableActionsDataModel(string action) { Extensions::immutableActionsDataModel(action) }

/**
 * MaD models for untrusted git commands
 * Fields:
 *    - cmd_regex: Regular expression for matching untrusted git commands
 *    - flag: Flag for the command
 */
predicate untrustedGitCommandDataModel(string cmd_regex, string flag) {
  Extensions::untrustedGitCommandDataModel(cmd_regex, flag)
}

/**
 * MaD models for untrusted gh commands
 * Fields:
 *    - cmd_regex: Regular expression for matching untrusted gh commands
 *    - flag: Flag for the command
 */
predicate untrustedGhCommandDataModel(string cmd_regex, string flag) {
  Extensions::untrustedGhCommandDataModel(cmd_regex, flag)
}
