import actions
import codeql.actions.config.ConfigExtensions as Extensions

from
  string path, string trigger, string job, string secrets_source, string permissions, string runner
where Extensions::workflowDataModel(path, trigger, job, secrets_source, permissions, runner)
select trigger, path, job, secrets_source, permissions, runner
