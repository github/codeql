import actions
import codeql.actions.dataflow.internal.ExternalFlowExtensions as Extensions

from
  string path, string visibility, string job, string secrets_source, string permissions,
  string runner
where Extensions::workflowDataModel(path, visibility, job, secrets_source, permissions, runner)
select visibility, path, job, secrets_source, permissions, runner
