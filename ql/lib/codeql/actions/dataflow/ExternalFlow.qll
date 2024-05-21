private import internal.ExternalFlowExtensions as Extensions
private import codeql.actions.DataFlow
private import actions

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
 * MaD sources
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - provenance: verification of the model
 */
predicate sourceModel(string action, string version, string output, string kind, string provenance) {
  Extensions::sourceModel(action, version, output, kind, provenance)
}

/**
 * MaD summaries
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input arg: From node (prefixed with either `env.` or `input.`)
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - kind: Either 'Taint' or 'Value'
 *    - provenance: verification of the model
 */
predicate summaryModel(
  string action, string version, string input, string output, string kind, string provenance
) {
  Extensions::summaryModel(action, version, input, output, kind, provenance)
}

/**
 * MaD sinks
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input: sink node (prefixed with either `env.` or `input.`)
 *    - kind: sink kind
 *    - provenance: verification of the model
 */
predicate sinkModel(string action, string version, string input, string kind, string provenance) {
  Extensions::sinkModel(action, version, input, kind, provenance)
}

predicate externallyDefinedSource(DataFlow::Node source, string sourceType, string fieldName) {
  exists(Uses uses, string action, string version, string kind |
    sourceModel(action, version, fieldName, kind, _) and
    uses.getCallee() = action.toLowerCase() and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    (
      if fieldName.trim().matches("env.%")
      then source.asExpr() = uses.getInScopeEnvVarExpr(fieldName.trim().replaceAll("env.", ""))
      else
        if fieldName.trim().matches("output.%")
        then source.asExpr() = uses
        else none()
    ) and
    sourceType = kind
  )
}

predicate externallyDefinedStoreStep(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c
) {
  exists(Uses uses, string action, string version, string input, string output |
    summaryModel(action, version, input, output, "taint", _) and
    c = any(DataFlow::FieldContent ct | ct.getName() = output.replaceAll("output.", "")) and
    uses.getCallee() = action.toLowerCase() and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    (
      if input.trim().matches("env.%")
      then pred.asExpr() = uses.getInScopeEnvVarExpr(input.trim().replaceAll("env.", ""))
      else
        if input.trim().matches("input.%")
        then pred.asExpr() = uses.getArgumentExpr(input.trim().replaceAll("input.", ""))
        else none()
    ) and
    succ.asExpr() = uses
  )
}

predicate externallyDefinedSink(DataFlow::Node sink, string kind) {
  exists(Uses uses, string action, string version, string input |
    sinkModel(action, version, input, kind, _) and
    uses.getCallee() = action.toLowerCase() and
    (
      if input.trim().matches("env.%")
      then sink.asExpr() = uses.getInScopeEnvVarExpr(input.trim().replaceAll("env.", ""))
      else
        if input.trim().matches("input.%")
        then sink.asExpr() = uses.getArgumentExpr(input.trim().replaceAll("input.", ""))
        else none()
    ) and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    )
  )
}
