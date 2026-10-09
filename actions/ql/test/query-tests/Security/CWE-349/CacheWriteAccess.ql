import actions
import codeql.actions.security.CachePoisoningQuery

from LocalJob job, Event event, boolean canWrite
where
  job.getWorkflow().getLocation().getFile().getBaseName() =
    [
      "cache_mode_reusable.yml", "cache_mode_nested.yml",
      "cache_write_capable_reusable_workflow.yml", "cache_write_capable_push.yml",
      "cache_write_capable_pull_request.yml"
    ] and
  job.getATriggerEvent() = event and
  (if hasDefaultBranchCacheWriteAccess(job, event) then canWrite = true else canWrite = false)
select job.getWorkflow().getLocation().getFile().getBaseName(), job.getId(),
  event.getLocation().getFile().getBaseName(), event.getName(), canWrite
